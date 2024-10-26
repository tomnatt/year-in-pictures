$(function() {
  $("a.year-menu-toggle, .year-menu-close").on("click", function() {
    $(".page-wrap").toggleClass("move-left");
  });
});

$(function() {
  $(".month-navigation ul li a").click(function() {
    var target = $(this).attr('href');
    $("html,body").animate({
      scrollTop: $(target).offset().top
    },"1000");
  })
})
