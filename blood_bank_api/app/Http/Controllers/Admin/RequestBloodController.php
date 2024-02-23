<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\RequestBlood;
use RealRashid\SweetAlert\Facades\Alert;

class RequestBloodController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
     
    $requestBlood = RequestBlood::orderBy('created_at', 'desc')->paginate(25); 

    // Iterate through each request blood and retrieve the count of available donors
    foreach ($requestBlood as $request) {
        $request->availableDonorsCount = $request->availableDonors()->count();
    }

    // Pass the data to the view
    return view('admin.blood.requestBlood', compact('requestBlood'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request)
    {
        $query = RequestBlood::query();
        $searchText = '';
    
        // Check if requiredDate is provided in the request
        if ($request->has('requiredDate')) {
            $requiredDate = $request->input('requiredDate');
            $query->where('requiredDate', 'like', '%' . $requiredDate . '%');
            $searchText .= $requiredDate;
        }
    
        // Check if hospitalName is provided in the request
        if ($request->has('hospitalName')) {
            $hospitalName = $request->input('hospitalName');
            $query->where('hospitalName', 'like', '%' . $hospitalName . '%');
            if ($searchText !== '') {
                $searchText .= ' ';
            }
            $searchText .= $hospitalName;
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
        $requestBlood = $query->orderBy('created_at', 'desc')->paginate(100);
    
        // Count the number of results
        $count = $requestBlood->count();
    
        // Prepare the message
        $message = "Showing $count results for search: $searchText";
    
        return view('admin.blood.requestBlood', compact('requestBlood', 'message'));
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
        $requestBlood = RequestBlood::where('requestId', $id)->first();
        // check if requestId exists or not
        if (!$requestBlood) {
            return redirect()->back()->with('message', 'Request not found or already deleted by the user.');
        }
        else{
            $requestBlood->delete();
            return redirect()->back()->with('message', 'Request Deleted Successfully');

        }
    }
}
