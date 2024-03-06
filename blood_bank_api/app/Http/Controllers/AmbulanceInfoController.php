<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AmbulanceInfo;
use App\Models\RegUser;


class AmbulanceInfoController extends Controller
{
    //
      //
      /*
      public function AmbulanceEntry(Request $request){

        $request->validate([            
            //'profilePic'=>'nullable',
            //'fullName' =>'required|string|',    
           // 'dob'=>'required',
           // 'gender' => 'required|string',
           // 'bloodGroup' =>'required',    
           // 'province' => 'required|digits:1',
           // 'district'=> 'required|string',
           // 'localLevel'=>'required|string',
           // 'wardNo' => 'required|integer',       
           // 'phoneNo' => 'required|digits:10',         
           // 'email' => 'required|email|unique:reg_users,email',
           // 'username' => 'required|unique:reg_users,username',
           // 'password' => 'required|min:8|confirmed',        
            
        ],
    );

        $ambulanceInfo= new AmbulanceEntry();       
        $ambulanceInfo -> name= $request -> post('name');
        $ambulanceInfo -> contactNo = $request -> post('contactNo');    
        $ambulanceInfo -> province = $request -> post('province');
        $ambulanceInfo -> district = $request -> post('district');
        $ambulanceInfo -> localLevel = $request -> post('localLevel');
        $ambulanceInfo -> wardNo = $request -> post('wardNo');
        $ambulanceInfo -> donorId = $request-> post('donorId');   
      //  $reg_users -> accountType= $request -> post('accountType');
        if($ambulanceInfo -> save()){
            return response()->json(['success' => true, 'message' => 'Registration Successful!'], 200);
        }

        else{
            return response()->json(['message'=>false],409);

        }
    }
    */

    public function LoadAmbulanceInfo(Request $request)
    {     

    
        $province = $request->input('province');
        $district = $request->input('district');
        $localLevel = $request->input('localLevel');
        $wardNo = $request->input('wardNo');

       
        $query = AmbulanceInfo::query(); // models SearchBlood

      

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

    public function regAmbulance(Request $request)
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
        $ambulance = new AmbulanceInfo();        
        $ambulance -> name= $request -> post('name');
        $ambulance -> province = $request -> post('province');
        $ambulance -> district = $request -> post('district');
        $ambulance -> localLevel = $request -> post('localLevel');
        $ambulance -> wardNo = $request -> post('wardNo');
        $ambulance -> contactNo = $request -> post('contactNo');
        $ambulance-> doId = $request->post('doId');

        // Check if the bloodbank was successfully created
        if ($ambulance -> save()) {
            return response()->json(['success' => true, 'message' => 'Ambulance data added successfully!'], 200);
        } else {
            return response()->json(['success' => false, 'message' => 'Failed to add ambulance.'], 400);
        }
      
    }









}
