<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AmbulanceInfo;

class AmbulanceInfoController extends Controller
{
    //
      //
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








}
