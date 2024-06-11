

# SmartCodable

**SmartCodable** is a data parsing library based on Swift's **Codable** protocol, designed to provide more powerful and flexible parsing capabilities. By optimizing and rewriting the standard features of **Codable**, **SmartCodable** effectively solves common problems in the traditional parsing process and improves the fault tolerance and flexibility of parsing.

**SmartCodable** 是一个基于Swift的**Codable**协议的数据解析库，旨在提供更为强大和灵活的解析能力。通过优化和重写**Codable**的标准功能，**SmartCodable** 有效地解决了传统解析过程中的常见问题，并提高了解析的容错性和灵活性。

```
struct Model: SmartCodable {
    var age: Int?
    var name: String = ""
}

let model = Model.deserialize(from: json)
```



## HandyJSON vs Codable

If you are using HandyJSON and would like to replace it, follow this link.

如果你正在使用HandyJSON，并希望替换掉它，请关注该链接。

 [SmartCodable - Compare With HandyJSON](https://github.com/intsig171/SmartCodable/blob/develop/Document/README/CompareWithHandyJSON.md)

| 序号 | 🎯 特性                        | 💬 特性说明 💬                                                 | SmartCodable | HandyJSON |
| ---- | ----------------------------- | ------------------------------------------------------------ | ------------ | --------- |
| 1    | **强大的兼容性**              | 完美兼容：**字段缺失** & **字段值为nul** & **字段类型错误**  | ✅            | ✅         |
| 2    | **类型自适应**                | 如JSON中是一个Int，但对应Model是String字段，会自动完成转化   | ✅            | ✅         |
| 3    | **解析Any**                   | 支持解析 **[Any], [String: Any]** 等类型                     | ✅            | ✅         |
| 4    | **解码回调**                  | 支持Model解码完成的回调，即：**didFinishingMapping**         | ✅            | ✅         |
| 5    | **属性初始化值填充**          | 当解析失败时，支持使用初始的Model属性的赋值。                | ✅            | ✅         |
| 6    | **字符串的Model化**           | 字符串是json字符串，支持进行Model化解析                      | ✅            | ✅         |
| 7    | **枚举的解析**                | 当枚举解析失败时，支持兼容。                                 | ✅            | ✅         |
| 8    | **属性的自定义解析** - 重命名 | 自定义解码key（对解码的Model属性重命名）                     | ✅            | ✅         |
| 9    | **属性的自定义解析** - 忽略   | 忽略某个Model属性的解码                                      | ✅            | ✅         |
| 10   | **支持designatedPath**        | 实现自定义解析路径                                           | ✅            | ✅         |
| 11   | **Model的继承**               | 在model的继承关系下，Codable的支持力度较弱，使用不便（可以支持） | ❌            | ✅         |
| 12   | **自定义解析路径**            | 指定从json的层级开始解析                                     | ✅            | ✅         |
| 13   | **超复杂的数据解码**          | 解码过程中，多数据做进一步的整合/处理。如： 数据的扁平化处理 | ✅            | ⚠️         |
| 14   | **解码性能**                  | 在解码性能上，SmartCodable 平均强 30%                        | ✅            | ⚠️         |
| 15   | **异常解码日志**              | 当解码异常进行了兼容处理时，提供排查日志                     | ✅            | ❌         |
| 16   | **安全性方面**                | 底层实现的稳定性和安全性。                                   | ✅            | ❌         |



## FAQ

If you're looking forward to learning more about the Codable protocol and the design thinking behind SmartCodable, check it out.

如果你期望了解更多Codable协议以及SmartCodable的设计思考，请关注它。	

[learn more about Codable & SmartCodable](https://github.com/intsig171/SmartCodable/blob/develop/Document/README/LearnMore.md)



## Use SmartCodable

### Installation - cocopods 

Add the following line to your `Podfile`:

```
pod 'SmartCodable'
```

Then, run the following command:

```
$ pod install
```

### Installation - Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/intsig171/SmartCodable.git`



### Usages

If you don't know how to use it, check it out.

如果你不知道如何使用，请查看它。

 [How do I use SmartCodable?](https://github.com/intsig171/SmartCodable/blob/develop/Document/README/Usages.md)




## Join us

**SmartCodable** is an open source project, and we welcome all developers interested in improving data parsing performance and robustness. Whether it's using feedback, feature suggestions, or code contributions, your participation will greatly advance the **SmartCodable** project.

**SmartCodable** 是一个开源项目，我们欢迎所有对提高数据解析性能和健壮性感兴趣的开发者加入。无论是使用反馈、功能建议还是代码贡献，你的参与都将极大地推动 **SmartCodable** 项目的发展。

![QQ](https://github.com/intsig171/SmartCodable/assets/87351449/5d3a98fe-17ba-402f-aefe-3e7472f35f82)
