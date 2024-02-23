<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SetAppointment;
use App\Models\RegDonor;

class SetAppointmentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $appointments = SetAppointment::with(['donor' => function ($query) {
            $query->select('fullName', 'phone', 'email', 'donorId');
        }])
        ->orderBy('created_at', 'desc')
        ->paginate(25);
    
        return view('admin.appointment.index', compact('appointments'));
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
        $query = SetAppointment::query();
        $searchText = '';
    
        // Check if requiredDate is provided in the request
        if ($request->has('setDate')) {
            $setDate = $request->input('setDate');
            $query->where('setDate', 'like', '%' . $setDate . '%');
            $searchText .= $setDate;
        }
         // Fetch request bloods based on the search criteria
         $appointments = $query->orderBy('created_at', 'desc')->paginate(100);
    
         // Count the number of results
         $count = $appointments->count();
     
         // Prepare the message
         $message = "Showing $count results for search: $searchText";
     
         return view('admin.appointment.index', compact('appointments', 'message'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
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
         // Find the record by requestId
         $appointments = SetAppointment::where('appointmentId', $id)->first();
         // check if requestId exists or not
         if (!$appointments) {
             return redirect()->back()->with('message', 'Data not found');
         }
         else{
             $appointments->delete();
             return redirect()->back()->with('message', 'Appointment deleted successfully');
         }
    }
}
