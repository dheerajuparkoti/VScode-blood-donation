<div class="btn-group" role="group">
    @if (isset($params['route']) && isset($params['id']))
        @if(!empty($params['show']))
            <a href="{{ route($params['route'].'.show', $params['id'])  }}" class="btn btn-info btn-sm blue btn-outline mr-1 pr-2"
               title="Details">
                <i class="fa fa-info"></i>
            </a>
        @endif
        @if (!empty($params['edit']))
            <a class="btn btn-info btn-sm blue btn-outline mr-1 pr-2" href="{{ route($params['route'].'.edit', [$params['name'] ?? null, $params['id']]) }}">
                <i class="la la-edit"></i>
            </a>
        @endif
        @if (!empty($params['delete']))
            <a class="btn btn-danger btn-sm blue btn-outline mr-1 pr-2" href="javascript:;"
               onclick="confirmation('delete-{{$params['id']}}')">
                <i class="la la-trash"></i>
{{--                {!! Form::open(['route' => [$params['route'].'.destroy',$params['id']], 'method' => 'delete', 'id'=>'delete-'.$params['id']]) !!}--}}
{{--                {!! Form::close() !!}--}}
            </a>
        @endif
    @endif
    {{ !empty($params['slot']) ? $params['slot'] : '' }}
    {!! !empty($params['otherLinks']) ? $params['otherLinks'] : '' !!}
</div>
<script type="text/javascript">
    function confirmation(formId) {
        Swal.fire({
            title: "Are you sure?",
            text: "You won't be able to revert this!",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, Do It!"
        }).then(function(result) {
            if (result.value) {
                document.getElementById(formId).submit();
                Swal.fire(
                    "Done!",
                    "Your action has been completed.",
                    "success"
                )
            }
        });
    };
</script>
