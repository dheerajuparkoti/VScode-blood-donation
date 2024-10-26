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
                            REGISTERED USERS
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
                <form action="{{ route('users-show') }}" method="GET">
                    <div class="form-row align-items-center mb-3">
                        <div class="col-auto">
                            <label class="sr-only" for="accountType">Account Type</label>
                            <input type="text" class="form-control" id="accountType" name="accountType" placeholder="Search by Account Type">
                        </div>
                        <div class="col-auto">
                            <label class="sr-only" for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Search by Username">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">Search Now</button>
                        </div>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="users-table">
                        <thead>
                            <tr class="table-primary">
                                <th>Id</th>
                                <th>Email</th>
                                <th>Username</th>
                                <th>Account Type</th>
                                <th>Change AC Type</th>
                                <th>Delete Account</th>                                                                                          
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($users as $user)
                            <tr>
                                <td>{{ $user->id }}</td>
                                <td>{{ $user->email }}</td>
                                <td>{{ $user->username }}</td>
                                <td>{{ $user->accountType }}</td>  
                                <td style="text-align: center; vertical-align: middle;">
                                    <form method="GET" action="{{ route('users-edit', ['id' => $user->id]) }}">
                                        @csrf
                                        <button type="submit" class="btn btn-warning" onclick="return confirm('Are you sure you want to change the account type of this user?')" style="padding: 5px 10px;">
                                            <div class="d-flex align-items-center justify-content-center">Change</div>
                                        </button>
                                    </form>
                                </td> 
                                <td style="text-align: center; vertical-align: middle;">
                                    <form method="POST" action="{{ route('users-delete', ['id' => $user->id]) }}">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this user? Once you delete, you won't be able to revert the changes.')" style="padding: 5px 10px;">
                                            <div class="d-flex align-items-center justify-content-center">Delete</div>
                                        </button>
                                    </form>
                                </td>                    
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
