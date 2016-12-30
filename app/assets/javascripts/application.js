// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require moment
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$(function() {
  $(".datepicker").datepicker({
  	format: "yyyy-mm-dd",
  	autoclose: true
  });
});

$(function() {
  $("#activity_from_time").timepicker({
  });
});

$(function() {
  $("#activity_to_time").timepicker({
  });
});

    
    $(function() {
      var toggle_repeats_yearly_on = function(){
        if($('#activity_repeats_yearly_on').is(':checked')){
          $('#activity_repeats_yearly_on_options').show();
        } else {
          $('#activity_repeats_yearly_on_options').hide();
        }
      }
      toggle_repeats_yearly_on();
      $('#activity_repeats_yearly_on').on('change',function(){
        toggle_repeats_yearly_on();
      });
      var toggle_activity_times = function(){
        if($('#activity_is_all_day').is(':checked')){
          $('.activity_time').hide();
        } else {
          $('.activity_time').show();
        }
      }
      toggle_activity_times();
      $('#activity_is_all_day').on('change',function(){
        toggle_activity_times();
      });
      var toggle_activity_options = function(){
        $('.activity_option').hide();
        switch ($('#activity_repeats').val())
        {
        case '':
          // Nothing
          break;
        case 'no':
          // Nothing
          break;
        case 'daily':
          $('#repeats_options').show();
          $('#repeats_daily_options').show();
          break;
        case 'weekly':
          $('#repeats_options').show();
          $('#repeats_weekly_options').show();
          break;
        case 'monthly':
          $('#repeats_options').show();
          $('#repeats_monthly_options').show();
          break;
        case 'yearly':
          $('#repeats_options').show();
          $('#repeats_yearly_options').show();
          break;
        }
      }
      toggle_activity_options();
      $('#activity_repeats').on('change',function(){
        toggle_activity_options();
      });
      var toggle_repeat_ends_on = function(){
      //  switch ($('#activity_repeat_ends').val())
      //  {
      //  case 'no':
      //    $('#activity_repeat_ends_on').hide();
      //    break;
      //  case 'yes':
          $('#activity_repeat_ends_on').show();
      //    break;
      //  }
      }
      toggle_repeat_ends_on();
      $('#activity_repeat_ends').on('change',function(){
        toggle_repeat_ends_on();
      });
      var toggle_repeats_monthly = function(){
        switch ($('#activity_repeats_monthly').val())
        {
        case 'each':
          //$('#activity_repeats_monthly_each').show();
          $('#activity_repeats_monthly_on').hide();
          break;
        case 'on':
          //$('#activity_repeats_monthly_each').hide();
          $('#activity_repeats_monthly_on').show();
          break;
        }
      }
      toggle_repeats_monthly();
      $('#activity_repeats_monthly').on('change',function(){
        toggle_repeats_monthly();
      });
    });


