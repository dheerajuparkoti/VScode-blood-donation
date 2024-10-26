<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\EmergencyRequestAvailableDonors;


class EmergencyRequestAvailableDonorsController extends Controller
{
    //
    public function erAvailableDonors(Request $request)
    {
        // Validation
        $request->validate([
            // Define your validation rules here
        ]);

        // Retrieve request data
        $erAvailableId = $request->input('erAvailableId');
        $donorAvailableId = $request->input('donorAvailableId');

        // Check if the donor is already available for the emergency request
        $existingDonor = EmergencyRequestAvailableDonors::where('erAvailableId', $erAvailableId)
            ->where('donorAvailableId', $donorAvailableId)
            ->exists();

        if ($existingDonor) {
            return response()->json(['success' => false, 'message' => 'Donor is already available for this emergency request'], 400);
        }

        // Create a new blood request donor record
        $bloodRequestDonor = new EmergencyRequestAvailableDonors();
        $bloodRequestDonor->erAvailableId = $erAvailableId;
        $bloodRequestDonor->donorAvailableId = $donorAvailableId;

        // Save the blood request donor record
        if ($bloodRequestDonor->save()) {
            return response()->json(['success' => true, 'message' => 'Blood request donor record created successfully'], 200);
        } else {
            return response()->json(['success' => false, 'message' => 'Failed to create blood request donor record'], 500);
        }
    }


       
    public function erAvailableDonorList(Request $request)
{
      // Retrieve the provided rAvailableId from the request
      $rAvailableId = $request->input('erAvailableId');

      // Retrieve data from the request_available_donors table and join with the reg_donors table
      $donorData = EmergencyRequestAvailableDonors::select('emergency_request_available_donors.erAvailableId', 'emergency_request_available_donors.donorAvailableId', 'reg_donors.fullname','reg_donors.profilePic')
          ->join('reg_donors', 'emergency_request_available_donors.donorAvailableId', '=', 'reg_donors.donorId')
          ->where('emergency_request_available_donors.erAvailableId', $rAvailableId)
          ->get();

      // Return the retrieved data
      return response()->json($donorData);
}



}
