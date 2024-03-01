<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\RegUser;
use App\Models\RegDonor;
use App\Models\DeviceToken;

use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class RegUserController extends Controller
{

    public function RegUser(Request $request)
    {
        // Check if the donor already exists in reg_donors table
        $existingDonor = RegDonor::where('phone', $request->input('phone'))
        ->orWhere('email', $request->input('email'))
        ->first();
      
        if ($existingDonor) {
            // Donor already exists, check if associated with a user
            $existingUser = RegUser::where('email', $existingDonor->email)->first();
            if (!$existingUser) {
                // Donor not associated with a user, create a new user
                $regUser = new RegUser();
                $regUser->email = $request->input('email'); // Corrected line
                $regUser->username = $request->input('username');
                $regUser->password = Hash::make($request->input('password'));
        
                if (!$regUser->save()) {
                    return response()->json(['error' => 'User registration failed'], 500);
                }
        
              
                // Update the reg_donors table where donorId matches the reg_user ID
                RegDonor::where('donorId', $existingDonor->donorId)->update([
               // 'fullName' => $request->input('fullName'),
               // 'dob' => $request->input('dob'),
               // 'gender' => $request->input('gender'),
               // 'bloodGroup' => $request->input('bloodGroup'),
               // 'province' => $request->input('province'),
               // 'district' => $request->input('district'),
               // 'localLevel' => $request->input('localLevel'),
               // 'wardNo' => $request->input('wardNo'),
              //  'phone' => $request->input('phone'),
                'email' => $request->input('email'),
                'userId'=> $regUser->id,
                ]);
                 // Create a new device token record associated with the user
                $deviceToken = new DeviceToken();
                $deviceToken->deviceToken = $request->post('deviceToken');
                $deviceToken->userId = $regUser->id;
                $deviceToken->save();                    
            }
        
            return response()->json([
                'success' => true,
                'message' => 'Donor registered as user',
                'userId' => $existingDonor->userId,
                'donorId' => $existingDonor->donorId
            ], 200);
        } else {

    // Donor does not exist, proceed with new registration
// Your code to create a new reg_user and reg_donor...


     // Validation rules
     $request->validate([
        'username' => 'required|unique:reg_users',
        'email' => 'required|email|unique:reg_users',
        'password' => 'required',
        'deviceToken' => 'required'
        // Add more validation rules as needed
    ]);

    // Create a new user record in reg_users table
    $reg_users = new RegUser();          
    $reg_users->email = $request->post('email');
    $reg_users->username = $request->post('username');
    $reg_users->password = Hash::make($request->post('password'));

    // Check if the user was successfully created
    if ($reg_users->save()) {
       
        // Create a new donor record associated with the user in reg_donors table
        $donor = RegDonor::create([
            'fullName' => $request->input('fullName'),
            'dob' => $request->input('dob'),
            'gender' => $request->input('gender'),
            'bloodGroup' => $request->input('bloodGroup'),
            'province' => $request->input('province'),
            'district' => $request->input('district'),
            'localLevel' => $request->input('localLevel'),
            'wardNo' => $request->input('wardNo'),
            'phone' => $request->input('phone'),
            'email' => $reg_users->email,
            'userId' => $reg_users->id,
        ]);

        // Create a new device token record associated with the user
        $deviceToken = new DeviceToken();
        $deviceToken->deviceToken = $request->post('deviceToken');
        $deviceToken->userId = $reg_users->id;
        $deviceToken->save();

        return response()->json(['success' => true, 'message' => 'User and donor registered successfully', 'id' => $reg_users->id], 201);

    } else {
        return response()->json(['message' => false], 409);
    }

}
    
       
    }

        // checks User existence or not for resetting password
        public function checkUserExists(Request $request)
        {
            $email = $request->input('email');
            $phone = $request->input('phone');
    
            // Check if the email exists in the reg_user table
            $userExists = RegUser::where('email', $email)->exists();
    
            // Check if the phone exists in the reg_donor table
            $donorExists = RegDonor::where('phone', $phone)->exists();
    
            // If both email and phone exist, update the password
            if ($userExists && $donorExists) {
                // Update the password in the reg_users table
                $user = RegUser::where('email', $email)->first();
                $user -> password = Hash::make($request -> post('new_password'));
                $user->save();
            }
    
            // Combine the results to determine overall existence
            $exists = $userExists && $donorExists;
    
            // Return a JSON response indicating whether the user exists or not
            return response()->json(['exists' => $exists]);
        }


        // settings Screen works
        //fetchUserData
        public function fetchingUserData(Request $request)
        {
            $userId = $request->input('id');
            $userData = RegUser::find($userId);
    
            if (!$userData) {
                return response()->json(['message' => 'User not found'], 404);
            }
         
            return response()->json(['data' => $userData], 200);

        }

        // updating user Data

        
// update donors profile 

    public function updateUserData(Request $request)
    {
        // Validate incoming request data
        $request->validate([
            'email' => 'required|email',
            'username' => 'required',
            'password' => 'nullable|min:8',
            'oldPassword' => 'nullable|required_with:password',
            'id' => 'required|exists:reg_users,id',
        ]);

        $userId = $request->input('id');
        $newEmail = $request->input('email');
        $newUsername = $request->input('username');
        $newPassword = $request->input('password');
        $oldPassword = $request->input('oldPassword');

        // Check if the old email provided matches the email in both reg_users and reg_donors tables
        $oldEmail = RegUser::where('id', $userId)->value('email');
        $matchedDonors = RegDonor::where('email', $oldEmail)->get();

        if ($oldEmail != $newEmail) {
            foreach ($matchedDonors as $donor) {
                if ($donor->userId == $userId) {
                    $donor->update(['email' => $newEmail]);
                }
            }
        }

        // Check if the new username is different from the old username associated with the userId
        $oldUsername = RegUser::where('id', $userId)->value('username');
        if ($oldUsername != $newUsername) {
            RegUser::where('id', $userId)->update(['username' => $newUsername]);
        }

        // Check if oldPassword is provided and matches the current password
        if ($oldPassword && Hash::check($oldPassword, RegUser::where('id', $userId)->value('password'))) {
            // Update password if old password matches
            RegUser::where('id', $userId)->update(['password' => Hash::make($newPassword)]);
        }

        // Update email in reg_users table
        RegUser::where('id', $userId)->update(['email' => $newEmail]);

        return response()->json(['message' => 'User data updated successfully'], 200);
    }

       

}
