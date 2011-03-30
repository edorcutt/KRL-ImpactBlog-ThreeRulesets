ruleset a169x275 {
    meta {
        name "KRL-ImpactBlog-ThreeRulesets-Data"
        description <<
            Kynetx Impact 2011 Blog demo with three Rulesets - Data
            http://www.lobosllc.com/demo/impactblog/index.html
    
            Application Variables:
                app:BlogRoll{}
        >>
        author "Ed Orcutt, LOBOSLLC"
        logging on
    }

    dispatch {
        domain "www.lobosllc.com"
    }

    global { }

    // ------------------------------------------------------------------------
    // Debug: Just used to clear the blog post data 

    rule ImpactBlog_Data_Reset is inactive {
        select when pageview ".*"
        { noop(); }
        always {
            clear app:BlogRoll;
        }
    }

    // ------------------------------------------------------------------------
    // Initialize the blog post hash on the first run

    rule ImpactBlog_Data_Init {
        select when explicit impactblog_data_init
        pre {
            BlogRoll = app:BlogRoll || {};
        }
        {
            watch("#blogform", "submit");
        }
        fired {
            set app:BlogRoll BlogRoll;
            raise explicit event blog_showall
        }
    }
    
    // ------------------------------------------------------------------------
    // Display all blog post in the Home panel

    rule ImpactBlog_Blog_ShowAll {
        select when explicit blog_showall
        foreach app:BlogRoll setting (postKey,postHash)
        pre {
            postAuthor = postHash.pick("$.author");
            postTitle  = postHash.pick("$.title");
            postBody   = postHash.pick("$.body");
            postTime   = postHash.pick("$.time");
            postArticle = <<
                <article class="post">
                  <header>
                    <h3>#{postTitle}</h3>
                    <p class="postinfo">Published on <time>#{postTime}</time></p>
                  </header>
                  <p>#{postBody}</p>
                  <footer>
                    <span class="author">#{postAuthor}</span>
                  </footer>
                </article>
            >>;
        }
        {
            prepend("div#blogroll", postArticle);
        }
    }
    
    // ------------------------------------------------------------------------
    // Save new blog post in hash

    rule ImpactBlog_Blog_Post_Submit {
        select when submit "#blogform"
        pre {
            postAuthor = page:param("postauthor");
            postTitle = page:param("posttitle");
            postBody = page:param("postbody");
            postTime = time:now({"tz":"America/Denver"});
            postHash = { postTime : {
                "author" : postAuthor,
                "title"  : postTitle,
                "body"   : postBody,
                "time"   : postTime
            }};
            BlogRoll = app:BlogRoll || {};
        }
        { noop(); }
        fired {
            set app:BlogRoll BlogRoll.put(postHash);
        }
    }
}
