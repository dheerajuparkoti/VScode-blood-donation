<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\SearchBlood;
use App\Models\RegUser;


class SearchBloodController extends Controller
{
    public function SearchBlood(Request $request)
    {
        $bloodGroup = $request->input('bloodGroup');
        $province = $request->input('province');
        $district = $request->input('district');
        $localLevel = $request->input('localLevel');
        $wardNo = $request->input('wardNo');

       
        $query = SearchBlood::query(); // models SearchBlood

        if ($bloodGroup) {
            $query->where('bloodGroup', $bloodGroup);
        }

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

        $userRegData = RegUser::select('id', 'accountType')
        ->get();

        $matchedResults = $query->get(['donorId', 'profilePic', 'fullname','dob','gender','bloodGroup','province','district','localLevel','wardNo','phone','email','userId']);
        $count = $matchedResults->count();

        // importing only count
        
     //  $count = $query->count();

       // return response()->json($count);

      
     
    
       \Log::info('Retrieved user data: ' . json_encode( $userRegData));
       \Log::info('Retrieved donor data: ' . json_encode( $matchedResults));
      return response()->json([
        'regUserData' => $userRegData,
        'count' => $count,
        'data' => $matchedResults,
       
    ]);
    
    
    
    





    }
}
