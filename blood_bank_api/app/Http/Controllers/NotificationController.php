<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Notification;
use Illuminate\Support\Facades\Log;

class NotificationController extends Controller
{
    public function loadNotification(Request $request)
    {
        $notifications = Notification::all();
        \Log::info('Retrieved all notification data: ' . json_encode($notifications));
        $count = count($notifications);
        \Log::info('Count is: ' . json_encode($count));
        return response()->json(['notifications' => $notifications, 'count' => $count],200);
    }
}
