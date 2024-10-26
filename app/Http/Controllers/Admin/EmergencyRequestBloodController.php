<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\EmergencyRequestBlood;

class EmergencyRequestBloodController extends Controller
{ 
    public function index()
    {
         $emergencyRequestBlood = EmergencyRequestBlood::orderBy('created_at', 'desc')->paginate(10);
        
        foreach ($emergencyRequestBlood as $emergencyRequest) {
            $emergencyRequest->availableDonorsCount = $emergencyRequest->availableDonors()->count();
        }

        return view('admin.blood.emergencyRequestBlood', compact('emergencyRequestBlood'));
    }
    
   
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
        $query = EmergencyRequestBlood::query();
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
        $emergencyRequestBlood = $query->orderBy('created_at', 'desc')->paginate(100);
    
        // Count the number of results
        $count = $emergencyRequestBlood->count();
    
        // Prepare the message
        $message = "Showing $count results for search: $searchText";
    
        return view('admin.blood.emergencyRequestBlood', compact('emergencyRequestBlood', 'message'));
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
    public function destroy(string $emergencyRequestId)
    {
         
        $emergencyRequestBlood = EmergencyRequestBlood::where('emergencyRequestId', $emergencyRequestId)->first();
     
        if (!$emergencyRequestBlood) {
            return redirect()->back()->with('message', 'Emergency Request not found or already deleted by the user.');
        }
        else{
            $emergencyRequestBlood->delete();
            return redirect()->back()->with('message', 'Emergency Request Deleted Successfully');

        }
    }
}
