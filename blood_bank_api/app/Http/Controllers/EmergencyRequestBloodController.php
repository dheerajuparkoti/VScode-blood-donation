<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\EmergencyRequestBlood;

class EmergencyRequestBloodController extends Controller
{
    //
    public function EmergencyRequestBlood(Request $request){

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

        $emergency_request_blood = new EmergencyRequestBlood(); 
        $emergency_request_blood -> fullName = $request -> post('fullName');
        $emergency_request_blood -> bloodGroup = $request-> post('bloodGroup');
        $emergency_request_blood -> requiredPint = $request-> post('requiredPint');
        $emergency_request_blood -> caseDetail = $request-> post('caseDetail');
        $emergency_request_blood -> contactPersonName = $request-> post('contactPersonName');
        $emergency_request_blood -> contactNo = $request-> post('contactNo');
        $emergency_request_blood -> requiredDate = $request-> post('requiredDate');
        $emergency_request_blood -> requiredTime = $request-> post('requiredTime');
        $emergency_request_blood -> hospitalName = $request-> post('hospitalName');
        $emergency_request_blood -> province = $request-> post('province');
        $emergency_request_blood -> district = $request-> post('district');
        $emergency_request_blood -> localLevel = $request-> post('localLevel');
        $emergency_request_blood -> wardNo = $request-> post('wardNo');       
        $emergency_request_blood -> doId = $request-> post('doId');    
      
        if($emergency_request_blood -> save()){
            return response()->json(['success' => true, 'message' => 'Request Successfully Created.'], 200);
        }

        else{
            return response()->json(['message'=>false],409);

        }
    }

    

/*
    public function LoadEmergencyRequests(Request $request)
    {
       

        $allRequests = EmergencyRequestBlood::orderBy('created_at', 'desc')->get();

        // Log the received user ID
        \Log::info('Received user ID: ' . $allRequests );
       
    
         // Log the retrieved data
         \Log::info('Retrieved all request blood data: ' . json_encode($allRequests));
    
         return response()->json([
             'emergencyRequestBloods' => $allRequests,
         ]);
       
    }
    */
    public function LoadEmergencyRequests(Request $request)
    {
        // Retrieve all emergency requests with the count of available donors
        $emergencyRequests = EmergencyRequestBlood::withCount('availableDonors')->orderBy('created_at', 'desc')->get();
    
        // Log the retrieved data
        \Log::info('Retrieved all emergency request blood data: ' . json_encode($emergencyRequests));
     // Extract the counts and map them to the request ID
    $donorCounts = $emergencyRequests->pluck('available_donors_count', 'emergencyRequestId');

    
        // Return response with emergency request data and count numbers
        return response()->json([
            'emergencyRequestBloods' => $emergencyRequests,
            'donorCounts' => $donorCounts,
       
        ]);
        
    }

    
// delte myRequest
public function deleteEmergencyRequest(Request $request)
{     
    // Validate the request data
    $request->validate([
        'emergencyRequestId' => 'required|exists:emergency_request_bloods,emergencyRequestId',
    ]);

    // Retrieve the request ID from the request
    $requestId = $request->input('emergencyRequestId');

    // Delete request from the request_bloods table
    $deleted = EmergencyRequestBlood::where('emergencyRequestId', $requestId)->delete();
    
    if ($deleted) {
        return response()->json(['message' => 'Emergency Request deleted successfully from Emergency_request_bloods table']);
    } else {
        return response()->json(['message' => 'Failed to delete Emergency request from Emergency_request_bloods table']);
    }
}

       
   

}
