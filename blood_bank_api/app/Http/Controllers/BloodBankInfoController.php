<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BloodBankInfo;   

class BloodBankInfoController extends Controller
{
    //
     //
     public function BloodBankEntry(Request $request){

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

        $bloodBankInfo = new BloodBankEntry();       
        $bloodBankInfo -> name= $request -> post('name');
        $bloodBankInfo -> contactNo = $request -> post('contactNo');    
        $bloodBankInfo -> province = $request -> post('province');
        $bloodBankInfo -> district = $request -> post('district');
        $bloodBankInfo -> localLevel = $request -> post('localLevel');
        $bloodBankInfo -> wardNo = $request -> post('wardNo');
        $bloodBankInfo -> donorId = $request-> post('donorId');   

        if($bloodBankInfo -> save()){
            return response()->json(['success' => true, 'message' => 'Registration Successful!'], 200);
        }

        else{
            return response()->json(['message'=>false],409);

        }
    }

    public function LoadBloodBankInfo(Request $request)
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



}
