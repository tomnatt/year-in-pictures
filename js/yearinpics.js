$(function() {
  $("a.year-menu-toggle, .year-menu-close").on("click", function() {
    $(".year-menu-toggle").attr("aria-expanded", function (i, attr) {
        return attr == "true" ? "false" : "true"
    });
    $(".page-wrap").toggleClass("move-left");
  });
});

$(function() {
  $(".month-navigation ul li a").click(function() {
    var target = $(this).attr("href");
    $("html,body").animate({
      scrollTop: $(target).offset().top
    },"1000");
  })
})
