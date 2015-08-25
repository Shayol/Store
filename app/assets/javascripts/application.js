// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .



var ready;
ready = function() {

  // $(".owl-carousel").owlCarousel({
  //   singleItem: true,
  //   navigation: true,
  //   slideSpeed : 300,
  //   paginationSpeed : 400,
  //   navigationText: ["<i class='fa fa-caret-left fa-5x'></i>","<i class='fa fa-caret-right fa-5x'></i>"]
  // });

  if($("#checkout_address_form_use_billing_as_shipping").is(":checked")) {
    $(".shipping_address_checkout").addClass("hidden");
  }

  $('#checkout_address_form_use_billing_as_shipping').change(function() {
  $(".shipping_address_checkout").toggleClass("hidden");
  });

};

$(document).ready(ready);
$(document).on('page:load', ready);