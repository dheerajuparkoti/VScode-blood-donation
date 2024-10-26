<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RequestAvailableDonors;
use App\Models\RegDonor;

class RequestAvailableDonorsController extends Controller
{
    //
    public function rAvailableDonors(Request $request)
    {
        // Validation
        $request->validate([
            // Define your validation rules here
        ]);

        // Retrieve request data
        $rAvailableId = $request->input('rAvailableId');
        $donorAvailableId = $request->input('donorAvailableId');

        // Check if the donor is already available for the emergency request
        $existingDonor = RequestAvailableDonors::where('rAvailableId', $rAvailableId)
            ->where('donorAvailableId', $donorAvailableId)
            ->exists();

        if ($existingDonor) {
            return response()->json(['success' => false, 'message' => 'Donor is already available for this request'], 400);
        }

        // Create a new blood request donor record
        $bloodRequestDonor = new RequestAvailableDonors();
        $bloodRequestDonor->rAvailableId = $rAvailableId;
        $bloodRequestDonor->donorAvailableId = $donorAvailableId;

        // Save the blood request donor record
        if ($bloodRequestDonor->save()) {
            return response()->json(['success' => true, 'message' => 'Blood request donor record created successfully'], 200);
        } else {
            return response()->json(['success' => false, 'message' => 'Failed to create blood request donor record'], 500);
        }
    }

    
    public function rAvailableDonorList(Request $request)
{
      // Retrieve the provided rAvailableId from the request
      $rAvailableId = $request->input('rAvailableId');

      // Retrieve data from the request_available_donors table and join with the reg_donors table
      $donorData = RequestAvailableDonors::select('request_available_donors.rAvailableId', 'request_available_donors.donorAvailableId', 'reg_donors.fullname','reg_donors.profilePic')
          ->join('reg_donors', 'request_available_donors.donorAvailableId', '=', 'reg_donors.donorId')
          ->where('request_available_donors.rAvailableId', $rAvailableId)
          ->get();

      // Return the retrieved data
      return response()->json($donorData);
}


    

  
}
