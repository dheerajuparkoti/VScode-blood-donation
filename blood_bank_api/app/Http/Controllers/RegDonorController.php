<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use App\Models\RegDonor;
use App\Models\RegUser;
use App\Models\DonationHistory;

class RegDonorController extends Controller
{
    //
    
    public function RegDonor(Request $request)
    {
         // Validation
    $request->validate([
        // Define your validation rules here
    ]);

    // Fetch user data from reg_user table
    $user = RegUser::find($request->post('userId'));

    // Check if user exists
    if (!$user) {
        return response()->json(['success' => false, 'message' => 'User not found.'], 404);
    }

    // Check accountType of the user
    if ($user->accountType === 'Member') {
        return response()->json(['success' => false, 'message' => 'You are not Admin.'], 400);
    }

        // Create a new donor in the reg_donors table
        $regDonor = new RegDonor();
        // $reg_users -> profilePic = $request -> post ('profilePic');
        $regDonor -> fullName= $request -> post('fullName');
        $regDonor -> dob = $request -> post('dob');
        $regDonor -> gender= $request -> post('gender');
        $regDonor -> bloodGroup= $request -> post('bloodGroup');
        $regDonor -> province = $request -> post('province');
        $regDonor -> district = $request -> post('district');
        $regDonor -> localLevel = $request -> post('localLevel');
        $regDonor -> wardNo = $request -> post('wardNo');
        $regDonor -> phone = $request -> post('phone');
        $regDonor -> email = $request -> post('email');
        $regDonor->userId = $request->post('userId');

       // $regDonor -> userId = $request-> post('userId');    
        
        // Check if the donor was successfully created
        if ($regDonor -> save()) {
            return response()->json(['success' => true, 'message' => 'Donor registration successful!'], 200);
        } else {
            return response()->json(['success' => false, 'message' => 'Failed to register donor.'], 400);
        }
    }
    

// count total members available and count blood group to show in main screen
public function DonorCountsByBloodGroup()
{
    $bloodGroups = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
    $counts = [];

    foreach ($bloodGroups as $group) {
        $count = RegDonor::where('bloodGroup', $group)->count();
        $counts[$group] = $count;
    }

    // Calculate total donors
    $totalDonors = array_sum($counts);

    return response()->json([
        'bloodGroupCounts' => $counts,
        'totalDonors' => $totalDonors,
    ]);
}


// list of 3 top donors 
public function getTopDonors()
{
    $topDonors = DonationHistory::select('doId', DB::raw('COUNT(doId) as donationCount'))
    ->groupBy('doId')
    ->orderByDesc('donationCount')
    ->take(3) // Fetch top 3 donors
    ->get();

$result = [];
foreach ($topDonors as $topDonor) {
    $donor = RegDonor::where('donorId', $topDonor->doId)->first();
    if ($donor) {
        $result[] = [
            'fullName' => $donor->fullName,
            'donationCount' => $topDonor->donationCount,
        ];
    }
}

return response()->json($result);
}







// update donors profile 
public function UpdateDonorProfile(Request $request)
{
    /* working for other data not picture

    // Validation
    $request->validate([
        // Define your validation rules here
    ]);

    // Fetch the donor from the reg_donors table based on the donorId
    $regDonor = RegDonor::find($request->post('donorId'));

    // Check if the donor exists
    if (!$regDonor) {
        return response()->json(['success' => false, 'message' => 'Donor not found.'], 404);
    }

    // Update the donor data
    $regDonor->fullName = $request->post('fullName');
    $regDonor->dob = $request->post('dob');
    $regDonor->gender = $request->post('gender');
    $regDonor->bloodGroup = $request->post('bloodGroup');
    $regDonor->province = $request->post('province');
    $regDonor->district = $request->post('district');
    $regDonor->localLevel = $request->post('localLevel');
    $regDonor->wardNo = $request->post('wardNo');
    $regDonor->phone = $request->post('phone');
    $regDonor->userId = $request->post('userId');

    // Save the updated donor data
    if ($regDonor->save()) {
        return response()->json(['success' => true, 'message' => 'Donor data updated successfully!'], 200);
    } else {
        return response()->json(['success' => false, 'message' => 'Failed to update donor data.'], 400);
    }
    */
 // Validation
 $request->validate([
    'image' => 'image|mimes:jpeg,png,jpg,gif|max:2048', // adjust the maximum file size as needed
    // Add your other validation rules here
]);

// Fetch the donor from the reg_donors table based on the donorId
$regDonor = RegDonor::find($request->post('donorId'));

// Check if the donor exists
if (!$regDonor) {
    return response()->json(['success' => false, 'message' => 'Donor not found.'], 404);
}
// Update the donor data based on user input
if ($request->filled('fullName')) {
    $regDonor->fullName = $request->post('fullName');
}
if ($request->filled('dob')) {
    $regDonor->dob = $request->post('dob');
}
if ($request->filled('gender')) {
    $regDonor->gender = $request->post('gender');
}
if ($request->filled('bloodGroup')) {
    $regDonor->bloodGroup = $request->post('bloodGroup');
}
if ($request->filled('province')) {
    $regDonor->province = $request->post('province');
}
if ($request->filled('district')) {
    $regDonor->district = $request->post('district');
}
if ($request->filled('localLevel')) {
    $regDonor->localLevel = $request->post('localLevel');
}
if ($request->filled('wardNo')) {
    $regDonor->wardNo = $request->post('wardNo');
}
if ($request->filled('phone')) {
    $regDonor->phone = $request->post('phone');
}
if ($request->filled('canDonate')) {
    $regDonor->canDonate = $request->post('canDonate');
}
if ($request->filled('userId')) {
    $regDonor->userId = $request->post('userId');
}

// Check if an image is uploaded
if ($request->hasFile('image')) {
    // Delete existing profile picture if any
    if ($regDonor->profilePic) {
        Storage::delete($regDonor->profilePic);
    }
    
    // Store the new profile picture
    $imagePath = $request->file('image')->store('profile_pictures');
    $regDonor->profilePic = $imagePath;
}
// Save the updated donor data
if ($regDonor->save()) {
    return response()->json(['success' => true, 'message' => 'Donor data updated successfully!'], 200);
} else {
    return response()->json(['success' => false, 'message' => 'Failed to update donor data.'], 400);
}

}

public function adminAddedDonors(Request $request)
{
    // Log the start of the method execution
    \Log::info('adminAddedDonors method started.');

    // Retrieve the provided userId from the request
    $userId = $request->input('id');

    // Log the retrieved userId
    \Log::info('Retrieved User Id: ' . $userId);

    // Get the email associated with the provided userId
    $userEmail = RegUser::where('id', $userId)->value('email');

    // Log the retrieved email
    \Log::info('Retrieved Email data: ' . $userEmail);

    // Retrieve data from the reg_donors table, joining with the reg_users table
    $donorData = RegDonor::select('reg_donors.donorId', 'reg_donors.fullname', 'reg_donors.profilePic')
        ->join('reg_users', 'reg_users.id', '=', 'reg_donors.userId')
        ->where('reg_donors.userId', $userId) // Match userId
        ->where('reg_donors.email', '!=', $userEmail) // Exclude donors with the same email as the user
        ->get();

    // Log the retrieved donor data
    \Log::info('Retrieved donor data: ' . json_encode($donorData));

    // Log the end of the method execution
    \Log::info('adminAddedDonors method completed.');

    // Return the retrieved data as JSON
    return response()->json($donorData);
}

}
