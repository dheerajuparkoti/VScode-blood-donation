<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\BloodBankInfo;
use Maatwebsite\Excel\Facades\Excel;
use App\Imports\Admin\BloodBankInfoImport;
use App\Exports\Admin\BloodBankInfoExport;
use App\Data\DistrictData;

class BloodBankInfoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $bloodBankInfo = BloodBankInfo::orderBy('created_at', 'desc')->paginate(25); 
        return view('admin.bloodbank.index',compact('bloodBankInfo'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $provinces = DistrictData::getProvinces();
        return view('admin.bloodbank.create', compact('provinces'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $storeData = $request->all();  
        // Set doId
        $storeData['doId'] = 1;
        
        // Create AmbulanceInfo instance with modified store data
        BloodBankInfo::create($storeData);
    
        return redirect()->route('admin-bloodbank-data')->with('message', 'Blood Bank data created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request)
    {
        $query = BloodBankInfo::query();
        $searchText = '';
    
        // Check if requiredDate is provided in the request
        if ($request->has('name')) {
            $name = $request->input('name');
            $query->where('name', 'like', '%' . $name . '%');
            $searchText .= $name;
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
        $bloodBankInfo = $query->orderBy('created_at', 'desc')->paginate(100);
    
        // Count the number of results
        $count = $bloodBankInfo->count();
    
        // Prepare the message
        $message = "Showing $count results for search: $searchText";
    
        return view('admin.bloodbank.index', compact('bloodBankInfo', 'message'));
    }

    public function storeImport(Request $request)
    {
        $file = $request->file('file');
        Excel::import(new BloodBankInfoImport, $file);
        
        return redirect()->route('admin-bloodbank-data')->with('success', 'All good!');
    }
    
    public function import()
    {
        return view('admin.bloodbank.import');
    }

    public function export() 
    {
               
        return Excel::download(new BloodBankInfoExport, 'bloodbankinfo.xlsx');
      
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
       $bloodBankInfo = BloodBankInfo::where('bloodBankInfoId', $id)->first();
       // check if requestId exists or not
       if (!$bloodBankInfo) {
           return redirect()->back()->with('message', 'Blood Bank data not found or already deleted by the user priliviges with admin.');
       }
       else{
           $bloodBankInfo->delete();
           return redirect()->back()->with('message', 'Blood Bank data deleted successfully');

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
