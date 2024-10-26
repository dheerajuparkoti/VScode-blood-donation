@extends('admin.layouts.master')
@section('content') 
<div class="m-content">
    <div class="m-portlet">
        <div class="m-portlet__head">
            <div class="m-portlet__head-wrapper">
                <div class="m-portlet__head-caption">
                    <div class="m-portlet__head-title">
                    <head>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
                            <link href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css" relation="stylesheet"> 
                    </head>
                        <h3 class="m-portlet__head-text">
                            APPOINTMENT REQUEST LIST
                        </h3>
                    </div>
                </div>
                <div class="m-portlet__head-tools">
                <a href="https://www.facebook.com/" class="btn btn-success m-btn m-btn--icon m-btn--wide m-btn--md m--margin-right-10">
                        <span>
                            <i class="fa fa-plus"></i>
                            <span>Create</span>
                        </span>                         
                    </a>
                    <!-- import button-->
                    <a href="https://www.facebook.com/" class="btn btn-primary m-btn m-btn--icon m-btn--wide m-btn--md m--margin-right-10">
                        <span>
                            <i class="fa fa-upload"></i>
                            <span>Import</span>
                        </span>
                    </a>
                   
                </div>
            </div>
        </div>
        <div class="m-portlet__body">
            <div class="m-section">
                <div class="m-section__content">
                    
                <!-- retrieving message from controller if deleted successfully-->  
                @if(session()->has('message'))
                <div class="alert alert-success">
                    {{ session()->get('message') }}
                </div>
                @endif

                @if(isset($message))
                <div class="alert alert-info">
                    {{ $message }}
                </div>
                @endif

                <!-- Search Bar -->
                <form action="{{ route('appointment-show') }}" method="GET">
                    <div class="form-row align-items-center mb-3">                                            
                       
                        <div class="col-auto">
                            <label class="sr-only" for="setDate">setDate</label>
                            <input type="text" class="form-control" id="setDate" name="setDate" placeholder="Search by Appointment Date">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">Search Now</button>
                        </div>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="ambulanceTable">
                        <thead>
                            <tr class="table-primary">
                                <th>SN</th>
                                <th>Appointment About</th>
                                <th>Appointment Date</th>                                
                                <th>Time</th>  
                                <th>Remarks</th>
                                <th>Sender Name</th> 
                                <th>Phone</th>
                                <th>Email</th> 
                                <th>Action</th>
                            </tr>
                        </thead>
                    
                    
                            <tbody>
                            @php $serial = 1; @endphp <!-- Initialize serial number counter -->
                                @foreach ($appointments as $appointment)
                                <tr class="dd">
                                    <td>{{ $serial++ }}</td>
                                    <td>{{ $appointment->about}}</td>
                                    <td>{{ $appointment->setDate}}</td> 
                                    <td>{{ $appointment->setTime}}</td> 
                                    <td>{{ $appointment->remarks}}</td>
                                    <td>{{ $appointment->donor->fullName}}</td>
                                    <td>{{ $appointment->donor->phone}}</td>
                                    <td>{{ $appointment->donor->email}}</td>
                                    <td style="text-align: center; vertical-align: middle;">
                                        <form method="POST" action="{{ route('appointment-delete', ['id' => $appointment->appointmentId]) }}">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this appointment? Once you delete, you will not be able to revert the changes!')" style="padding: 5px 10px;">
                                                <div class="d-flex align-items-center justify-content-center">Delete</div>
                                            </button>
                                        </form>
                                    </td>                    
                                </tr>
                                @endforeach
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="12">
                                        <!-- Pagination links -->
                                        <div class="pagination justify-content-center">
                                            {{ $appointments->onEachSide(2)->links() }}
                                        </div>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>      
            </div>
            </div>
        </div>
    </div>
</div>
@endsection
