<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\LoadRequest;
use App\Models\RegDonor;
use App\Models\RequestBlood;
use App\Models\EmergencyRequestBlood;

class LoadRequestController extends Controller
{


    /*working code just previous one
    // load my requests only from other requests and emergency requests
       public function LoadMyRequests(Request $request)
    {
        $donorId = $request->input('doId');

        // Log the received user ID
    \Log::info('Received user ID: ' . $donorId);

        // Assuming User model has relationships with methods that are declared in RegUser model
        
     

       
      //   Retrieve data only from request_bloods and emergency_request_bloods tables
        $requestBloods = RequestBlood::select('requestId', 'fullName', 'bloodGroup', 'requiredPint', 'caseDetail', 'contactPersonName', 'contactNo', 'requiredDate', 'requiredTime', 'hospitalName', 'province', 'district', 'localLevel', 'wardNo', 'doId', 'created_at', 'updated_at')
        ->where('doId', $donorId)
        ->orderBy('created_at', 'desc')
        ->get();
            
        $emergencyRequestBloods = EmergencyRequestBlood::select('emergencyRequestId', 'fullName', 'bloodGroup', 'requiredPint', 'caseDetail', 'contactPersonName', 'contactNo', 'requiredDate', 'requiredTime', 'hospitalName', 'province', 'district', 'localLevel', 'wardNo', 'doId', 'created_at', 'updated_at')
        ->where('doId', $donorId)
        ->orderBy('created_at', 'desc')
        ->get();

        return response()->json([
            'requestBloods' => $requestBloods,
            'emergencyRequestBloods' => $emergencyRequestBloods,
        ]);
        
                  // Log the retrieved user data
    \Log::info('Retrieved user data: ' . json_encode($requestBloods));
    \Log::info('Retrieved user data: ' . json_encode($emergencyRequestBloods));

  
}

*/
/*



public function LoadMyRequests(Request $request)
{
    $donorId = $request->input('doId');

    // Retrieve data from both requestBloods and emergencyRequestBloods tables
    $requestBloods = RequestBlood::select('requestId', 'fullName', 'bloodGroup', 'requiredPint', 'caseDetail', 'contactPersonName', 'contactNo', 'requiredDate', 'requiredTime', 'hospitalName', 'province', 'district', 'localLevel', 'wardNo', 'doId', 'created_at', 'updated_at')
        ->withCount('availableDonors') // Retrieve donor count for each requestBlood
        ->where('doId', $donorId)
        ->orderBy('created_at', 'desc')
        ->get();
            
    $emergencyRequestBloods = EmergencyRequestBlood::select('emergencyRequestId', 'fullName', 'bloodGroup', 'requiredPint', 'caseDetail', 'contactPersonName', 'contactNo', 'requiredDate', 'requiredTime', 'hospitalName', 'province', 'district', 'localLevel', 'wardNo', 'doId', 'created_at', 'updated_at')
        ->withCount('availableDonors') // Retrieve donor count for each emergencyRequestBlood
        ->where('doId', $donorId)
        ->orderBy('created_at', 'desc')
        ->get();

    // Return response with both types of requests and their associated donor counts
    return response()->json([
        'requestBloods' => $requestBloods,
        'emergencyRequestBloods' => $emergencyRequestBloods,
    ]);
}
*/

public function LoadMyRequests(Request $request)
{
    $donorId = $request->input('doId');

    // Retrieve data for normal requests with donor count
    $requestBloods = RequestBlood::withCount('availableDonors')
        ->where('doId', $donorId)
        ->orderBy('created_at', 'desc')
        ->get();

    // Retrieve data for emergency requests with donor count
    $emergencyRequestBloods = EmergencyRequestBlood::withCount('availableDonors')
        ->where('doId', $donorId)
        ->orderBy('created_at', 'desc')
        ->get();

    return response()->json([
        'requestBloods' => $requestBloods,
        'emergencyRequestBloods' => $emergencyRequestBloods,

        \Log::info('Count is  ' . json_encode( $requestBloods)),
    ]);
}

/*
public function LoadMyRequests(Request $request)
{
    $donorId = $request->input('doId');

    // Retrieve data for regular requests
    $requestBloods = RequestBlood::withCount('availableDonors')
        ->where('doId', $donorId)
        ->orderBy('created_at', 'desc')
        ->get();

    // Retrieve data for emergency requests
    $emergencyRequestBloods = EmergencyRequestBlood::withCount('availableDonors')
        ->where('doId', $donorId)
        ->orderBy('created_at', 'desc')
        ->get();

    // Extract donor counts for regular requests and emergency requests
    $requestDonorCounts = $requestBloods->pluck('available_donors_count', 'requestId');
    $emergencyRequestDonorCounts = $emergencyRequestBloods->pluck('available_donors_count', 'emergencyRequestId');

    // Return response with request and emergency request data, along with donor counts
    return response()->json([
        'requestBloods' => $requestBloods,
        'emergencyRequestBloods' => $emergencyRequestBloods,
        'requestDonorCounts' => $requestDonorCounts,
        'emergencyRequestDonorCounts' => $emergencyRequestDonorCounts,
    ]);
}

*/






/*
        
    // Join the tables and select only the columns you want
    $user = RegUser::join('request_bloods AS A', 'reg_users.id', '=', 'A.userId')
        ->join('emergency_request_bloods AS B', 'reg_users.id', '=', 'B.userId')
        ->where('reg_users.id', $userId)
        ->select(
            'A.requestId', 'A.fullName', 'A.bloodGroup',
            'A.requiredPint', 'A.caseDetail', 'A.contactPersonName',
            'A.contactNo', 'A.requiredDate', 'A.requiredTime',
            'A.hospitalName', 'A.province', 'A.district',
            'A.localLevel', 'A.wardNo', 'A.userId',
            'A.created_at', 'A.updated_at',            
            'B.emergencyRequestId', 'B.fullName',
            'B.bloodGroup', 'B.requiredPint',
            'B.caseDetail', 'B.contactPersonName',
            'B.contactNo', 'B.requiredDate',
            'B.requiredTime', 'B.hospitalName',
            'B.province', 'B.district',
            'B.localLevel', 'B.wardNo',
            'B.userId', 'B.created_at',
            'B.updated_at'
        )
        ->first();
                 // $requestBloods = $user->request_bloods ?? [];
           // $emergencyRequestBloods = $user->emergency_request_bloods ?? [];

        return response()->json([
            'myRequestsData' => $user,
        ]);
        
*/
       


/*
public function LoadOtherRequests(Request $request)
{
    $userId = $request->input('userId');

    // Log the received user ID
    \Log::info('Received user ID: ' . $userId);

    // Retrieve data only from request_bloods table where userId is not equal to the provided user ID
    $requestBloods = RequestBlood::select('requestId', 'fullName', 'bloodGroup', 'requiredPint', 'caseDetail', 'contactPersonName', 'contactNo', 'requiredDate', 'requiredTime', 'hospitalName', 'province', 'district', 'localLevel', 'wardNo', 'userId', 'created_at', 'updated_at')
        ->where('userId', '!=', $userId)
        ->get();

    \Log::info('Retrieved user data: ' . json_encode($requestBloods));
    return response()->json([
        'otherRequestBloods' => $requestBloods ?? [],
    ]);
   
}
*/

/*
public function LoadEmergencyRequests(Request $request)
{
     $userId = $request->input('userId');

    // Log the received user ID
    \Log::info('Received user ID: ' . $userId);

    // Retrieve data only from request_bloods table where userId is not equal to the provided user ID
        $requestBloods =EmergencyRequestBlood ::select('requestId', 'fullName', 'bloodGroup', 'requiredPint', 'caseDetail', 'contactPersonName', 'contactNo', 'requiredDate', 'requiredTime', 'hospitalName', 'province', 'district', 'localLevel', 'wardNo', 'userId', 'created_at', 'updated_at')
        ->where('userId', '!=', $userId)
        ->get();

    \Log::info('Retrieved user data: ' . json_encode($requestBloods));
    return response()->json([
        'emergencyRequestBloods' => $requestBloods ?? [],
    ]);
   
}
*/

   
   
}
