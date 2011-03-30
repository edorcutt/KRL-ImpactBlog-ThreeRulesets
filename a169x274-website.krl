ruleset a169x274 {
    meta {
        name "KRL-ImpactBlog-ThreeRulesets-Website"
        description <<
            Kynetx Impact 2011 Blog demo with three Rulesets - Website
            http://www.lobosllc.com/demo/impactblog/index.html
        >>
        author "Ed Orcutt, LOBOSLLC"
        logging on
    }

    dispatch { }

    global {
        Ruleset_Data = "a169x275";
    }
    
    // ------------------------------------------------------------------------
    // Initialize the blog page when first run, attach watches to buttons

    rule ImpactBlog_Init {
        select when pageview ".*"
        // select when web impactblog_init
        {
            watch("#siteNavHome",  "click");
            watch("#siteNavAbout", "click");
            watch("#siteNavPost", "click");
        }
        fired {
            raise explicit event impactblog_data_init for Ruleset_Data;
        }
    }
    
    // ------------------------------------------------------------------------
    // Site Navigation button clicked: Home

    rule ImpactBlog_SiteNav_Home {
        select when click "#siteNavHome"
        {
            // flush any blog post displayed
            replace_inner("div#blogroll", "");

            // hide all panel, then show the home panel
            emit <|
                $K(".dynacontainer").hide('slow');
                $K("#dynahome").show('slow');
            |>;
        }
        fired {
            raise explicit event blog_showall for Ruleset_Data;
        }
    }
    
    // ------------------------------------------------------------------------
    // Site Navigation button clicked: About

    rule ImpactBlog_SiteNav_About {
        select when click "#siteNavAbout"
        {
            // hide all panel, then show the about panel
            emit <|
                $K(".dynacontainer").hide('slow');
                $K("#dynaabout").show('slow');
            |>;
        }
    }
    
    // ------------------------------------------------------------------------
    // Site Navigation button clicked: Post

    rule ImpactBlog_SiteNav_Post {
        select when click "#siteNavPost"
        {
            // hide all panel, then show the post panel
            emit <|
                $K(".dynacontainer").hide('slow');
                $K("#dynapost").show('slow');
            |>;
        }
    }
}
