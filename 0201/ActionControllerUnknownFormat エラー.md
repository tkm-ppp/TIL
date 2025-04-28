# ActionController::UnknownFormat エラー

## 今回のエラー文
```
ActionController::UnknownFormat in Users::SessionsController#new
ActionController::UnknownFormat
Extracted source (around line #218):
216
217
218
219
220
221
              
        (options.delete(:responder) || self.class.responder).call(self, resources, options)
      else
        raise ActionController::UnknownFormat
      end
    end
```

`ActionController::UnknownFormat`
= リクエストされたフォーマットに対して、テンプレートがないよという意味
  つまり、今回で言うと、UserSessionsController#newに対応するviewがないため発生したエラーのようです