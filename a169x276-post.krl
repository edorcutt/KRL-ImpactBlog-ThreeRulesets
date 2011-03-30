ruleset a169x276 {
    meta {
        name "KRL-ImpactBlog-ThreeRulesets-Post"
        description <<
            Kynetx Impact 2011 Blog demo with three Rulesets - Post
            http://www.lobosllc.com/demo/impactblog/index.html
        >>
        author "Ed Orcutt, LOBOSLLC"
        logging on
    }

    dispatch {
        domain "www.lobosllc.com"
    }

    global { }
  
    // ------------------------------------------------------------------------
    // Initialize by unhiding the Post site navigation option

    rule ImpactBlog_Browser_Init {
        select when pageview ".*"
        {
            emit <| $K("#siteNavPost").show(); |>;
        }
    }
}
