<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\RegUser;
use App\Models\RegDonor;

class RegUserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $users = RegUser::all();
        return view('admin.blood.users', compact('users'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request)
    {
        $query = RegUser::query();
        $searchText = '';

        // Check if accountType is provided in the request
        if ($request->has('accountType')) {
            $accountType = $request->input('accountType');
            $query->where('accountType', 'like', '%' . $accountType . '%');
            $searchText .= $accountType;
        }

        // Check if username is provided in the request
        if ($request->has('username')) {
            $username = $request->input('username');
            $query->where('username', 'like', '%' . $username . '%');
            if ($searchText !== '') {
                $searchText .= ' ';
            }
            $searchText .= $username;
        }

        // Fetch users based on the search criteria
        $users = $query->get();

        // Count the number of users
        $count = $users->count();

        // Prepare the message
        $message = "Showing $count results for search: $searchText";

        return view('admin.blood.users', compact('users', 'message'));

    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the user from the database
        $user = RegUser::findOrFail($id);
        
        // Check the current account type and update it
        if ($user->accountType == 'Admin') {
            $user->accountType = 'Member';
        } else {
            $user->accountType = 'Admin';
        }
    
        // Save the changes to the user model
        $user->save();
        
        // Optionally, redirect back to a specific route or return a response
        return redirect()->back()->with('message', "Account type updated successfully. New account type for {$user->username} is {$user->accountType}");
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
           // Retrieve user by ID
        $deleteUser = RegUser::find($id);
        
        // Check if user exists
        if (!$deleteUser) {
            return response()->json(['message' => 'User not found'], 404);
        }

        // Retrieve email of the user
        $userEmail = $deleteUser->email;

        // Check if there's a donor with the same email
        $matchingDonor = RegDonor::where('email', $userEmail)->first();

        // If a matching donor is found, delete it
        if ($matchingDonor) {
            $matchingDonor->delete();
        }

        // Delete the user
        $deleteUser->delete();     

        return redirect()->back()->with('message', 'User Deleted Successfully');
        }

}

