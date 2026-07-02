require("minuet").setup {
    provider = "openai_fim_compatible",
    provider_options = {
        openai_fim_compatible = {
            model = "deepseek-v4-pro",
            end_point = "https://api.deepseek.com/beta/completions",
            api_key = require("config.secret").deepseek,
            name = "deepseek",
            stream = true,
            optional = {
                max_tokens = 256,
                top_p = 0.9,
            },
        },
    }
}