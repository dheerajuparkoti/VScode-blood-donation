<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use App\Models\SetAppointment;

class SetAppointmentController extends Controller
{
    //
    public function setAppointment(Request $request){

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

        $set_appointment = new SetAppointment(); 
        $set_appointment -> about = $request -> post('about');
        $set_appointment -> setDate = $request-> post('setDate');
        $set_appointment -> setTime = $request-> post('setTime');
        $set_appointment -> remarks = $request-> post('remarks');       
        $set_appointment -> doId = $request-> post('doId');    
      
        if($set_appointment -> save()){
            return response()->json(['success' => true, 'message' => 'Request Successfully Created.'], 200);
        }

        else{
            return response()->json(['message'=>false],409);

        }
    }

}
