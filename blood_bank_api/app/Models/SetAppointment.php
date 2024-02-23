<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SetAppointment extends Model
{
    use HasFactory;
    protected $table = 'set_appointments';
    protected $primaryKey = 'appointmentId';

    public function donor()
    {
        return $this->belongsTo(RegDonor::class, 'doId', 'donorId');
    }

}
