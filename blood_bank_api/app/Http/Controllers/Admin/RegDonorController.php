<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\RegDonor;
use App\Models\RegUser;
use Maatwebsite\Excel\Facades\Excel;
use App\Imports\Admin\RegDonorImport;
use App\Exports\Admin\RegDonorExport;
use App\Data\DistrictData;

class RegDonorController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        /*
        $donors = RegDonor::orderBy('created_at', 'desc')->paginate(25); 
        return view('admin.donor.index',compact('donors'));
        */
        $donors = RegDonor::with('user') // Eager load the 'user' relationship
                  ->orderBy('created_at', 'desc')
                  ->paginate(25);

return view('admin.donor.index', compact('donors'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $provinces = DistrictData::getProvinces();
        return view('admin.donor.create', compact('provinces'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $storeData = $request->all();  
        // Set userId
        $storeData['userId'] = 15;
        
        // Create AmbulanceInfo instance with modified store data
        RegDonor::create($storeData);
    
        return redirect()->route('admin-donor-data')->with('message', 'Donor data created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request)
    {
        $query = RegDonor::query();
        $searchText = '';
    
        
        if ($request->has('username')) {
            $username = $request->input('username');
    
            // Find the user by username
            $user = RegUser::where('username', $username)->first();
    
            if ($user) {
                // If user exists, get the user's id
                $userId = $user->id;
    
                // Use the user's id to search for donors
                $query->where('userId', $userId);
              
            }
            $searchText .= $username ;
        }

        if ($request->has('bloodGroup')) {
            $bloodGroup = $request->input('bloodGroup');
            $query->where('bloodGroup', 'like', '%' . $bloodGroup . '%');
            $searchText .= $bloodGroup;
        }

        if ($request->has('phone')) {
            $phone = $request->input('phone');
            $query->where('phone', 'like', '%' . $phone . '%');
            $searchText .= $phone;
        }

        if ($request->has('email')) {
            $email= $request->input('email');
            $query->where('email', 'like', '%' . $email . '%');
            $searchText .= $email;
        }

        if ($request->has('canDonate')) {
            $canDonate = $request->input('canDonate');
            $query->where('canDonate', 'like', '%' . $canDonate . '%');
            $searchText .= $canDonate;
        }

        if ($request->has('gender')) {
            $gender = $request->input('gender');
            $query->where('gender', 'like', '%' . $gender . '%');
            $searchText .= $gender;
        }
        // Check if address is provided in the request
        if ($request->has('address')) {
            $address = $request->input('address');
            $query->where(function ($query) use ($address) {
                $query->where('localLevel', 'like', '%' . $address . '%')
                    ->orWhere('wardNo', 'like', '%' . $address . '%')
                    ->orWhere('district', 'like', '%' . $address . '%')
                    ->orWhere('province', 'like', '%' . $address . '%');
            });
            if ($searchText !== '') {
                $searchText .= ' ';
            }
            $searchText .= $address;
        }

      
        // Fetch request bloods based on the search criteria
        $donors = $query->orderBy('created_at', 'desc')->paginate(100);
    
        // Count the number of results
        $count = $donors->count();
    
        // Prepare the message
        $message = "Showing $count results for search: $searchText";
    
        return view('admin.donor.index', compact('donors', 'message'));
    }
    
    public function import()
    {
        return view('admin.donor.import');
    }

    public function storeImport(Request $request)
    {
        $file = $request->file('file');
        Excel::import(new RegDonorImport, $file);
        
        return redirect()->route('admin-donor-data')->with('success', 'All good!');
    }
    


    public function export() 
    {
               
        return Excel::download(new RegDonorExport, 'donorlist.xlsx');
      
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Find the record by requestId
       $donors = RegDonor::where('donorId', $id)->first();
       // check if requestId exists or not
       if (!$donors) {
           return redirect()->back()->with('message', 'Donor data not found or already deleted.');
       }
       else{
           $donors->delete();
           return redirect()->back()->with('message', 'Donor data deleted successfully');

       }
    }
    
    public function getDistricts(Request $request)
    {
        $provinceId = $request->province_id;
        $districts = DistrictData::getDistricts($provinceId);
        return response()->json($districts);
    }

    public function getLocalLevels(Request $request)
    {
        $districtName = $request->district_name;
        $localLevels = DistrictData::getLocalLevels($districtName);
        return response()->json($localLevels);
    }
}
