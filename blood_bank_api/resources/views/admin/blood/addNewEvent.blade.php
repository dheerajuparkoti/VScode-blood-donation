@extends('admin.layouts.master')
@section('content') 
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">Add New Event</div>
                <head>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
                            <link href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css" relation="stylesheet"> 
                    </head>

                <div class="card-body">
                    <form method="POST" action="{{route('event-store')}}">
                        @csrf

                        <div class="form-group row">
                            <label for="eventName" class="col-md-4 col-form-label text-md-right">Event Name</label>

                            <div class="col-md-6">
                                <input id="eventName" type="text" class="form-control @error('eventName') is-invalid @enderror" name="eventName" value="{{ old('eventName') }}" required autocomplete="eventName" autofocus>

                                @error('eventName')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="venue" class="col-md-4 col-form-label text-md-right">Venue</label>

                            <div class="col-md-6">
                                <input id="venue" type="text" class="form-control @error('venue') is-invalid @enderror" name="venue" value="{{ old('venue') }}" required autocomplete="venue">

                                @error('venue')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="chiefGuest" class="col-md-4 col-form-label text-md-right">Chief Guest</label>

                            <div class="col-md-6">
                                <input id="chiefGuest" type="text" class="form-control @error('chiefGuest') is-invalid @enderror" name="chiefGuest" value="{{ old('chiefGuest') }}" autocomplete="chiefGuest">

                                @error('chiefGuest')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="eventDetail" class="col-md-4 col-form-label text-md-right">Event Detail</label>

                            <div class="col-md-6">
                                <textarea id="eventDetail" class="form-control @error('eventDetail') is-invalid @enderror" name="eventDetail" required autocomplete="eventDetail">{{ old('eventDetail') }}</textarea>

                                @error('eventDetail')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="organizedBy" class="col-md-4 col-form-label text-md-right">Organized By</label>

                            <div class="col-md-6">
                                <input id="organizedBy" type="text" class="form-control @error('organizedBy') is-invalid @enderror" name="organizedBy" value="{{ old('organizedBy') }}" autocomplete="organizedBy">

                                @error('organizedBy')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="contactNo" class="col-md-4 col-form-label text-md-right">Contact No</label>

                            <div class="col-md-6">
                                <input id="contactNo" type="text" class="form-control @error('contactNo') is-invalid @enderror" name="contactNo" value="{{ old('contactNo') }}" autocomplete="contactNo">

                                @error('contactNo')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="province" class="col-md-4 col-form-label text-md-right">Province</label>

                            <div class="col-md-6">
                                <input id="province" type="text" class="form-control @error('province') is-invalid @enderror" name="province" value="{{ old('province') }}" required autocomplete="province">

                                @error('province')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="district" class="col-md-4 col-form-label text-md-right">District</label>

                            <div class="col-md-6">
                                <input id="district" type="text" class="form-control @error('district') is-invalid @enderror" name="district" value="{{ old('district') }}" required autocomplete="district">

                                @error('district')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="localLevel" class="col-md-4 col-form-label text-md-right">Local Level</label>

                            <div class="col-md-6">
                                <input id="localLevel" type="text" class="form-control @error('localLevel') is-invalid @enderror" name="localLevel" value="{{ old('localLevel') }}" required autocomplete="localLevel">

                                @error('localLevel')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="wardNo" class="col-md-4 col-form-label text-md-right">Ward No</label>

                            <div class="col-md-6">
                                <input id="wardNo" type="text" class="form-control @error('wardNo') is-invalid @enderror" name="wardNo" value="{{ old('wardNo') }}" required autocomplete="wardNo">

                                @error('wardNo')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="eventDate" class="col-md-4 col-form-label text-md-right">Event Date</label>

                            <div class="col-md-6">
                                <input id="eventDate" type="date" class="form-control @error('eventDate') is-invalid @enderror" name="eventDate" value="{{ old('eventDate') }}" required autocomplete="eventDate">

                                @error('eventDate')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="eventTime" class="col-md-4 col-form-label text-md-right">Event Time</label>

                            <div class="col-md-6">
                                <input id="eventTime" type="time" class="form-control @error('eventTime') is-invalid @enderror" name="eventTime" value="{{ old('eventTime') }}" required autocomplete="eventTime">

                                @error('eventTime')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                        </div>

                        <input type="hidden" name="doId" value="2"> <!-- Default value for doId -->

                        <div class="form-group row mb-0">
                            <div class="col-md-6 offset-md-4">
                                <button type="submit" class="btn btn-primary">
                                    Add Event
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
