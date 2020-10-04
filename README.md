# MAFetch

![Build iOS](https://github.com/chicio/ID3TagEditor/workflows/Build%20iOS/badge.svg)

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/chicio/ID3TagEditor/master/LICENSE.md)

[![Platform](https://img.shields.io/cocoapods/p/MAKit.svg?style=flat)](https://cocoapods.org/pods/MAKit)

<li><img src="https://files.virgool.io/upload/users/6345/posts/wv8hmp6rnx2a/jjm22t1chsk9.jpeg" alt="one"/></li>

## Example

To run the example project, clone the repo, and run Code from the Example directory first.

### Usage

MAFetch is compatible with the following platforms:

* iOS
* AF
* FetchSettings
* reachability
* FetchSession
* propertyWrapper - Fetch

Below you can find a sample code of the api usage.

```swift

// MARK: - Welcome
struct Welcome: Codable {
    let message: Message
    let data: [String]
}

// MARK: - Message
struct Message: Codable {
    let status: Int
    let text: String
}


extension APIClient {
    
    @Fetch<Welcome>(BaseURL.defults.base,method:.get)
    static var fetchState: Service<Welcome>
    
    @Fetch<Welcome>(BaseURL.defults.base,method:.post)
    static var fetchStatePost: Service<Welcome>
    
}

```
Simple Add....
* set Method with Parameters
* usage set

```swift
extension APIClient {
    
    
    func state(complation:@escaping (Welcome)->Void) {
        APIClient.$fetchState
            .set(path: "/cities/state")
        
        APIClient.fetchState { model in
            complation(model)
        }
    }
    
    
    func postState(id:Int,complation:@escaping (Welcome)->Void) {
        APIClient.$fetchStatePost
            .set(path: "/cities/post/state")
            .set(headers: ["ApplicationJson":"ContentType"])
            .set(parameters: .body(["id":id])) // with URL and Form
        
        APIClient.fetchStatePost { model in
            complation(model)
        }
    }
    
   
    
}
```
***** Simple *****

```swift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
    }
      
    func fetchData() {
        
        APIClient.share.state { model in
            print(model.data)
        }
        
    }   
}

```




## Installation

MAFetch is available easy use ....

## Author

MIAkbari, akbari4mb@gmail.com

## License

MAKit is available under the MIT license. See the LICENSE file for more info.
