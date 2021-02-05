// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require chartkick
//= require Chart.bundle
//= require_tree .
/*global $ */

// スライドショー
$(document).on('turbolinks:load', function () {
  $('.slick-wrapper').slick({
    dots: true,
    autoplay: true,
    autoplaySpeed: 1200
  });
});

// 画像プレビュー
$(document).on('turbolinks:load', function () {
  function readURL(input) {
    if (input.files && input.files[0]) {
      let reader = new FileReader();
      reader.onload = function (e) {
        $('.image-preview').attr('src', e.target.result);
      };
      reader.readAsDataURL(input.files[0]);
    }
  }
  $('.image-field').change(function () {
    readURL(this);
  });
});

// モーダルウィンドウ
$(document).on('turbolinks:load', function () {
  $('.js-modal-open').each(function(){
    $(this).on('click',function(){
      let target = $(this).data('target');
      let modal = document.getElementById(target);
      $(modal).fadeIn();
      return false;
    });
  });
  $('.js-modal-close').on('click',function(){
    $('.js-modal').fadeOut();
    return false;
  });
});
