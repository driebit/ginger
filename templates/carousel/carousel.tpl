<style>
    .carousel li {
        display: inline-block;
        width: 30px;
    }
</style>

<h1>carousel</h1>

{% include "carousel/carousel.tpl"
    items=m.rsc.gallerytest.o.haspart
    itemtemplate="carousel/carousel-]item.tpl"
    pagertemplate="carousel/carousel-pager-item.tpl"
    extraClasses=""
    carousel_id="testcarousel"
    config="{
        infinite: true,
        slidesToShow: 3,
        slidesToScroll: 1,
        arrows: false
    }"
%}
