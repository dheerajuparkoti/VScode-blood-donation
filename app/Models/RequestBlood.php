<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestBlood extends Model
{
    use HasFactory;
    protected $table = 'request_bloods';
    protected $primaryKey = 'requestId';

    public function availableDonors()
    {
        return $this->hasMany(RequestAvailableDonors::class, 'rAvailableId', 'requestId');
    }

}
