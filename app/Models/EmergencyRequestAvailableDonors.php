<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EmergencyRequestAvailableDonors extends Model
{
    use HasFactory;
    protected $table = 'emergency_request_available_donors';
    protected $primarykey = 'id';
    
}
