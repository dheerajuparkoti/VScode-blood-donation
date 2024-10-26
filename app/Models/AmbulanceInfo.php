<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AmbulanceInfo extends Model
{
    use HasFactory;
    protected $table = 'ambulance_infos';
    protected $primaryKey = 'ambulanceInfoId';
    protected $guarded = ['id'];
}
