<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;
    protected $table = 'notifications';
    protected $primaryKey = 'notId';
    protected $fillable = [
        'rId',
        'erId',
        'evId',
        'doId',
        // Add other fillable fields here if needed
    ];

    // Your model code here...

    // Define mutator to ensure at least one non-nullable field is present
    public function setAnyNonNullAttribute($value)
    {
        // Do nothing, this is just to satisfy the mutator requirement
    }
}
