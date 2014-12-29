$(function() {
  $(document).foundation();
});

$(function() {
  $(".month-navigation ul li a").click(function() {
    var target = $(this).attr('href');
    $("html,body").animate({
      scrollTop: $(target).offset().top
    },"1000");
  })
})
