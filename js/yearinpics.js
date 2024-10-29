$(function() {

  $("a.year-menu-toggle, .year-menu-close").on("click", function() {
    $(".year-menu-toggle").attr("aria-expanded", function (i, attr) {
      return attr == "true" ? "false" : "true"
    });
    $(".page-wrap").toggleClass("move-left");
  });

  $("a.year-menu-toggle, .year-menu-close").on("keypress", function(e) {
    if(e.key == "Enter") {
      $(".year-menu-toggle").attr("aria-expanded", function (i, attr) {
        return attr == "true" ? "false" : "true"
      });
      $(".page-wrap").toggleClass("move-left");
    }
  });

  // $(".year-menu aside ul li a").on("focus", function() {
  $(".year-menu-toggle").on("focus", function() {
    $(".year-menu-toggle").attr("aria-expanded", function (i, attr) {
      return attr == "true" ? "false" : "true"
    });
    $(".page-wrap").toggleClass("move-left");
  });

  $('[TabIndex="30"]').on("focus", function() {
    $(".year-menu-toggle").attr("aria-expanded", function (i, attr) {
      return attr == "true" ? "false" : "true"
    });
    $(".page-wrap").toggleClass("move-left");
  });

  $(".month-navigation ul li a").click(function() {
    var target = $(this).attr("href");
    $("html,body").animate({
      scrollTop: $(target).offset().top
    },"1000");
  });
});
