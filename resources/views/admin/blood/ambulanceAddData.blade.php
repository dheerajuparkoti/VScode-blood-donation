@extends('admin.layouts.master')
@section('content') 
<div class="m-content">
    <div class="m-portlet">
        <div class="m-portlet__head">
            <div class="m-portlet__head-wrapper">
                <div class="m-portlet__head-caption">
                    <div class="m-portlet__head-title">
                        <h3 class="m-portlet__head-text">
                            AMBULANCE SEWA
                        </h3>
                    </div>
                </div>
                <div class="m-portlet__head-tools">
                   
                </div>
            </div>
        </div>
        <div class="m-portlet__body">
            <div class="m-section">
                <div class="m-section__content">
                    <!-- Add Ambulance Form -->
                    <form method="POST" action="{{ route('admin.blood-ambulance-add') }}">
                        @csrf
                        <div class="form-group">
                            <label for="name">Name:</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="contact_no">Contact Number:</label>
                            <input type="text" class="form-control" id="contact_no" name="contact_no" required>
                        </div>
                        <div class="form-group">
                            <label for="province">Province:</label>
                            <input type="text" class="form-control" id="province" name="province" required>
                        </div>
                        <div class="form-group">
                            <label for="district">District:</label>
                            <input type="text" class="form-control" id="district" name="district" required>
                        </div>
                        <div class="form-group">
                            <label for="local_level">Local Level:</label>
                            <input type="text" class="form-control" id="local_level" name="local_level" required>
                        </div>
                        <div class="form-group">
                            <label for="ward_no">Ward Number:</label>
                            <input type="text" class="form-control" id="ward_no" name="ward_no" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Add Ambulance</button>
                    </form>
                    <!-- End Add Ambulance Form -->
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
