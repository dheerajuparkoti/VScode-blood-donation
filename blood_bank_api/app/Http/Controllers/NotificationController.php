<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Notification;
use Illuminate\Support\Facades\Log;

class NotificationController extends Controller
{
    public function loadNotification(Request $request)
    {
        $notifications = Notification::whereNull('doId')
                                  ->orderBy('created_at', 'desc')
                                  ->get();
       
        $count = count($notifications);
        
        return response()->json(['notifications' => $notifications, 'count' => $count],200);
    }

    public function notificationReadErId(Request $request)
    {             
        // Validate the request data
        $validatedData = $request->validate([
            'erId' => 'required|exists:notifications,erId',
            'doId' => 'required',
        ], [
            'erId.exists' => 'The notification with the provided erId does not exist.',
        ]); 


    
        // Find the notification by ID
        $notification = Notification::where('erId', $validatedData['erId'])
                                    ->where('doId', $validatedData['doId'])
                                    ->first();
                                 
        if ($notification) {
            // Update the isRead status
            $notification->isRead = true;        
            $notification->save();
            Log::info('Notification saved successfully');

            return response()->json(['message' => 'Notification successfully marked as read'], 200);
        } else {
            // Create a new notification
            Notification::create([
                'erId' => $validatedData['erId'],              
                'doId' => $validatedData['doId'],
                'isRead' => true,
            ]);
            return response()->json(['message' => 'Notification created and marked as read'], 200);
        }
    }

    
    public function notificationReadReId(Request $request)
    {             
        // Validate the request data
        $validatedData = $request->validate([
            'rId' => 'required|exists:notifications,rId',
            'doId' => 'required',
        ], [
            'erId.exists' => 'The notification with the provided erId does not exist.',
        ]); 
    
        // Find the notification by ID
        $notification = Notification::where('rId', $validatedData['rId'])
                                    ->where('doId', $validatedData['doId'])
                                    ->first();
                                    
    
        if ($notification) {
            // Update the isRead status
            $notification->isRead = true;
            $notification->save();
            return response()->json(['message' => 'Notification successfully marked as read'], 200);
        } else {
            // Create a new notification
            Notification::create([
              
                'rId' => $validatedData['rId'],              
                'doId' => $validatedData['doId'],
                'isRead' => true,
                
            ]);
            return response()->json(['message' => 'Notification created and marked as read'], 200);
        }
    }


    public function notificationReadEvent(Request $request)
    {             
        // Validate the request data
        $validatedData = $request->validate([
            'evId' => 'required|exists:notifications,evId',
            'doId' => 'required',
        ], [
            'erId.exists' => 'The notification with the provided erId does not exist.',
        ]); 
    
        // Find the notification by ID
        $notification = Notification::where('evId', $validatedData['evId'])
                                    ->where('doId', $validatedData['doId'])
                                    ->first();
                                    
    
        if ($notification) {
            // Update the isRead status
            $notification->isRead = true;
            $notification->save();
            return response()->json(['message' => 'Notification successfully marked as read'], 200);
        } else {
            // Create a new notification
            Notification::create([
                'evId' => $validatedData['evId'],              
                'doId' => $validatedData['doId'],
                'isRead' => true,
            ]);
            return response()->json(['message' => 'Notification created and marked as read'], 200);
        }
    }
}


