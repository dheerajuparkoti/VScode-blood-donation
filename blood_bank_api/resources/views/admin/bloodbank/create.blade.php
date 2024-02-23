@extends('admin.layouts.master')

@section('content')
<div class="m-content">
    <div class="m-portlet">
        <div class="m-portlet__head">
            <div class="m-portlet__head-wrapper">
                <div class="m-portlet__head-caption">
                    <div class="m-portlet__head-title">
                        <h3 class="m-portlet__head-text">
                            ADD NEW BLOOD BANK DATA 
                        </h3>
                    </div>
                </div>
                <div class="m-portlet__head-tools">
                </div>
            </div>
        </div>
        <div class="m-portlet__body">
            {!! Form::model(null, ['route' => ['admin-bloodbank-store'], 'method' => 'post', 'class' => 'kt-form kt-form--label-right', 'id' => 'grade-form']) !!}
            @include('admin.bloodbank.form', ['formAction' => 'Save'])
            {!! Form::close() !!}
        </div>
    </div>
</div>
@endsection
