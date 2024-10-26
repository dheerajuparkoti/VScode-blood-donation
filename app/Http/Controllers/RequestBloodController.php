<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RequestBlood;

class RequestBloodController extends Controller
{
    //
    public function requestBlood(Request $request){

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

        $request_blood = new RequestBlood(); 
        $request_blood -> fullName = $request -> post('fullName');
        $request_blood -> bloodGroup = $request-> post('bloodGroup');
        $request_blood -> requiredPint = $request-> post('requiredPint');
        $request_blood -> caseDetail = $request-> post('caseDetail');
        $request_blood -> contactPersonName = $request-> post('contactPersonName');
        $request_blood -> contactNo = $request-> post('contactNo');
        $request_blood -> requiredDate = $request-> post('requiredDate');
        $request_blood -> requiredTime = $request-> post('requiredTime');
        $request_blood -> hospitalName = $request-> post('hospitalName');
        $request_blood -> province = $request-> post('province');
        $request_blood -> district = $request-> post('district');
        $request_blood -> localLevel = $request-> post('localLevel');
        $request_blood -> wardNo = $request-> post('wardNo');
        $request_blood -> doId = $request-> post('doId');    
      
        if($request_blood -> save()){
            return response()->json(['success' => true, 'message' => 'Request Successfully Created.'], 200);
        }

        else{
            return response()->json(['message'=>false],409);

        }
    }


      
public function loadOtherRequests(Request $request)
{
    //$allRequests = RequestBlood::all(); // ascending order 

    $allRequests = RequestBlood::withCount('availableDonors')->orderBy('created_at', 'desc')->get();
    
    // Extract the counts and map them to the request ID
    $donorCounts = $allRequests->pluck('available_donors_count', 'requestId');
 
     return response()->json([
         'otherRequestBloods' => $allRequests,
         'donorCounts' => $donorCounts,
         \Log::info('Count is  ' . json_encode($donorCounts)),
     ]);
     
   
}


// delte myRequest
public function deleteRequest(Request $request)
{     
    // Validate the request data
    $request->validate([
        'requestId' => 'required|exists:request_bloods,requestId',
    ]);

    // Retrieve the request ID from the request
    $requestId = $request->input('requestId');
    \Log::info('requestId  ' . json_encode($requestId));

    // Delete request from the request_bloods table
    $deleted = RequestBlood::where('requestId', $requestId)->delete();
    \Log::info('deleted  ' . json_encode($deleted));
    
    if ($deleted) {
        return response()->json(['message' => 'Request deleted successfully from request_bloods table']);
    } else {
        return response()->json(['message' => 'Failed to delete request from request_bloods table']);
    }
}

}
