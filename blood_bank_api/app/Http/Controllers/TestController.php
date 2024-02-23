<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\test;

class TestController extends Controller
{
    public function test(Request $request){

        $request->validate([
            'name' => 'required|string|max:255',
            'age' => 'required|string|max:255',
            // other validation rules...
        ]);

        $tests = new test();// 
        $tests -> name = $request ->post('name');
        $tests -> age = $request->post('age');
        if($tests->save()){
            return response()->json(['success' => true, 'message' => 'Registration Successful!'], 200);

           // return response()->json(['message'=>true],200);

        }
        else{
            return response()->json(['message'=>false],409);

        }
     
      

    }
}
