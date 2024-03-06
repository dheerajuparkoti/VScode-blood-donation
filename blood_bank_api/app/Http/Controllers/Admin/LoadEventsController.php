<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\LoadEvents;
use App\Models\EventStatus;

class LoadEventsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
    
        
        // Retrieve events along with their status counts
        $events = LoadEvents::withCount(['statuses as likes' => function ($query) {
            $query->where('like', true);
        }, 'statuses as attendees' => function ($query) {
            $query->where('attend', true);
        }])->orderBy('created_at', 'desc')->paginate(25);

        return view('admin.event.index', compact('events'));
        
    
    }
    public function addEvent(){
        return view('admin.event.form');
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
    
        // Validate the request data
        $validatedData = $request->validate([
            'eventName' => 'required|string|max:255',
            'venue' => 'required|string|max:255',
            'chiefGuest' => 'nullable|string|max:255',
            'eventDetail' => 'required|string',
            'organizedBy' => 'nullable|string|max:255',
            'contactNo' => 'required|string|max:10',
            'province' => 'required|string|max:255',
            'district' => 'required|string|max:255',
            'localLevel' => 'required|string|max:255',
            'wardNo' => 'required|string|max:10',
            'eventDate' => 'required|date',
            'eventTime' => 'required|date_format:H:i',
            'doId' => 'required|integer',
        ]);

        // Create a new LoadEvents instance with the validated data
        $event = new LoadEvents();
        $event->eventName = $validatedData['eventName'];
        $event->venue = $validatedData['venue'];
        $event->chiefGuest = $validatedData['chiefGuest'];
        $event->eventDetail = $validatedData['eventDetail'];
        $event->organizedBy = $validatedData['organizedBy'];
        $event->contactNo = $validatedData['contactNo'];
        $event->province = $validatedData['province'];
        $event->district = $validatedData['district'];
        $event->localLevel = $validatedData['localLevel'];
        $event->wardNo = $validatedData['wardNo'];
        $event->eventDate = $validatedData['eventDate'];
        $event->eventTime = $validatedData['eventTime'];
      //  $event->doId = $validatedData['doId'];
        $event->doId = 3;

        // Save the event
        $event->save();

        // Redirect back with a success message
        return redirect()->route('admin-event-data')->with('message', 'New event has been added successfully.');
    
       
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request)
    {
        $query = LoadEvents::query();
        $searchText = '';
    
        // Check if requiredDate is provided in the request
        if ($request->has('eventName')) {
            $eventName = $request->input('eventName');
            $query->where('eventName', 'like', '%' . $eventName . '%');
            $searchText .= $eventName;
        }

        if ($request->has('eventDate')) {
            $eventDate = $request->input('eventDate');
            $query->where('eventDate', 'like', '%' . $eventDate . '%');
            $searchText .= $eventDate;
        }    

        // Check if address is provided in the request
        if ($request->has('address')) {
            $address = $request->input('address');
            $query->where(function ($query) use ($address) {
                $query->where('localLevel', 'like', '%' . $address . '%')
                    ->orWhere('wardNo', 'like', '%' . $address . '%')
                    ->orWhere('district', 'like', '%' . $address . '%')
                    ->orWhere('province', 'like', '%' . $address . '%');
            });
            if ($searchText !== '') {
                $searchText .= ' ';
            }
            $searchText .= $address;
        }
    
        // Fetch request bloods based on the search criteria
        $events = $query->orderBy('created_at', 'desc')->paginate(100);

         // Loop through events to fetch likes and attendees count
        foreach ($events as $event) {
        $event->likes = $event->statuses()->where('like', true)->count();
        $event->attendees = $event->statuses()->where('attend', true)->count();
        }
    
        // Count the number of results
        $count = $events->count();
    
        // Prepare the message
        $message = "Showing $count results for search: $searchText";
    
        return view('admin.event.index', compact('events', 'message'));
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
         $events = LoadEvents::where('eventId', $id)->first();
         // check if requestId exists or not
         if (!$events) {
             return redirect()->back()->with('message', 'Event data not found or already deleted!');
         }
         else{
             $events->delete();
             return redirect()->back()->with('message', 'Event data deleted successfully');
 
         }
    }
}
