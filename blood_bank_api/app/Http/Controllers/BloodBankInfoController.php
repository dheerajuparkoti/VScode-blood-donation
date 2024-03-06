<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BloodBankInfo;   
use App\Models\RegUser;

class BloodBankInfoController extends Controller
{
 

    public function loadBloodBankInfo(Request $request)
    {     
        $province = $request->input('province');
        $district = $request->input('district');
        $localLevel = $request->input('localLevel');
        $wardNo = $request->input('wardNo');       
        $query = BloodBankInfo::query(); // models SearchBlood

      

        if ($province) {
            $query->where('province', $province);
        }

        if ($district) {
            $query->where('district', $district);
        }

        if ($localLevel) {
            $query->where('localLevel', $localLevel);
        }

        if ($wardNo) {
            $query->where('wardNo', $wardNo);
        }


        $matchedResults = $query->get(['name', 'contactNo','province','district','localLevel','wardNo']);
        $count = $matchedResults->count();

      return response()->json([
        'count' => $count,
        'data' => $matchedResults,
    ]);
    
       
    }

    
    public function regBloodBank(Request $request)
    {
    // Validation
    $request->validate([
        "name" => "required",
        "province" => "required", 
        "district" => "required",
        "localLevel"=>"required",
        "wardNo"=>"required",
        "doId"=> "required",
        "userId" => "required|exists:reg_users,id", // Check if userId exists in reg_users table
        "contactNo"=>"required"
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

        // Create a new blood bank data
        $bloodbank = new BloodBankInfo();        
        $bloodbank -> name= $request -> post('name');
        $bloodbank -> province = $request -> post('province');
        $bloodbank -> district = $request -> post('district');
        $bloodbank -> localLevel = $request -> post('localLevel');
        $bloodbank -> wardNo = $request -> post('wardNo');
        $bloodbank -> contactNo = $request -> post('contactNo');
        $bloodbank-> doId = $request->post('doId');

        // Check if the bloodbank was successfully created
        if ($bloodbank -> save()) {
            return response()->json(['success' => true, 'message' => 'Blood Bank data added successfully!'], 200);
        } else {
            return response()->json(['success' => false, 'message' => 'Failed to add blood bank.'], 400);
        }
    }


}
