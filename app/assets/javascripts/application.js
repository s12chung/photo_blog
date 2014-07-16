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
//= require jquery_ujs
//= require jcontroller
//= require_self
//= require_tree ./lib
//= require_tree ./behaviors
//= require_tree ./jcontrollers

function data_behavior(behavior) {
    return "[data-behavior~='" + behavior + "']";
}
function defined(variable) {
    return typeof variable != 'undefined' && variable != null;
}
function blank(variable) {
    return !defined(variable);
}

function flowtype(options) {
    $('body').flowtype(options);
}
Behavior = {};