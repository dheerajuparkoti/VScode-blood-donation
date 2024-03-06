<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\LoadRequest;
use App\Models\RegDonor;
use App\Models\RequestBlood;
use App\Models\EmergencyRequestBlood;

class LoadRequestController extends Controller
{


public function loadMyRequests(Request $request)
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





       


   
   
}
