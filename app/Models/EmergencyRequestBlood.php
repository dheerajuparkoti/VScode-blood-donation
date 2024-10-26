<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EmergencyRequestBlood extends Model
{
    use HasFactory;
    protected $table = 'emergency_request_bloods';
    protected $primaryKey = 'emergencyRequestId';

    public function availableDonors()
    {
        return $this->hasMany(EmergencyRequestAvailableDonors::class, 'erAvailableId', 'emergencyRequestId');
    }


}



