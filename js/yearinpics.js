$(function() {

  $("a.year-menu-toggle, .year-menu-close").on("click", function() {
    toggleYearMenu();
  });

  $("a.year-menu-toggle, .year-menu-close").on("keypress", function(e) {
    if(e.key == "Enter") {
      toggleYearMenu();
    }
  });

  $('.year-menu-toggle, [TabIndex="30"]').focus(function() {
    toggleYearMenu();
  });

  $(".month-navigation ul li a").click(function() {
    var target = $(this).attr("href");
    $("html,body").animate({
      scrollTop: $(target).offset().top
    },"1000");
  });
});

function toggleYearMenu() {
  $(".year-menu-toggle").attr("aria-expanded", function (i, attr) {
    return attr == "true" ? "false" : "true"
  });
  $(".page-wrap").toggleClass("move-left");
}
