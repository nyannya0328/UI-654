//
//  Home.swift
//  UI-654
//
//  Created by nyannyan0328 on 2022/08/27.
//

import SwiftUI

struct Home: View {
    @State var blurView : UIVisualEffectView = .init()
    @State var defaultBlurRadius : CGFloat = 0
    @State var defalutStaturationAmount : CGFloat = 0
    
    @State var activeGrassMorphism : Bool = false
    
 
    var body: some View {
        ZStack{
            
            Color("BG")
                .ignoresSafeArea()
      
            
            Image("TopCircle")
                .offset(x:150,y:-30)
            
            Image("BottomCircle")
                .offset(x:-150,y:60)
            
            Image("CenterCircle")
                .offset(x:-50,y:-30)
            
            
          Toggle("Active Grass Morphism", isOn: $activeGrassMorphism)
                .font(.title3.weight(.semibold))
                .onChange(of: activeGrassMorphism, perform: { newValue in
                    
                    blurView.gaussianBlurRadius = (activeGrassMorphism ? 10 : defaultBlurRadius)
                    blurView.satulationAmount = (activeGrassMorphism ? 1.8 : defalutStaturationAmount)
                    
                })
                  .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .bottom)
                  .padding(15)
          
        
            GlassMorphicCard()
        
        }
    }
    
    @ViewBuilder
    func GlassMorphicCard ()->some View{
        
        ZStack{
            
            CustomBlurView(effect: .systemThickMaterialDark) { view in
                
                blurView = view
                if defaultBlurRadius == 0{ defaultBlurRadius = view.gaussianBlurRadius}
                if defalutStaturationAmount == 0{
                    
                    
                    defalutStaturationAmount = view.satulationAmount
                }
                   
            
            }
            .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
            
            
            RoundedRectangle(cornerRadius: 10,style: .continuous)
                .fill(
                
                    LinearGradient(colors: [
                    
                    
                        .white.opacity(0.25),
                        .white.opacity(0.05)
                    
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                )
                .blur(radius: 5)
            
            
            RoundedRectangle(cornerRadius: 10,style: .continuous)
                .stroke(
                
                    LinearGradient(colors: [
                    
                    
                        .white.opacity(0.6),
                        .clear,
                        .purple.opacity(0.2),
                        .purple.opacity(0.5)
                    
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                )
                .shadow(color : .black.opacity(0.15), radius: 5,x: -10,y: -10)
                .shadow(color : .black.opacity(0.15), radius: 5,x: 10,y: -10)
                .overlay {
                    
                    
                    CardContent()
                        .opacity(activeGrassMorphism ? 1 : 0)
                        .animation(.easeIn(duration: 0.5), value: activeGrassMorphism)
                    
                    
                }
            
            
            
           
        }
        .padding(.horizontal,25)
        .frame(height:250)
        
    }
    @ViewBuilder
    func CardContent()->some View{
        
        VStack(alignment:.leading,spacing: 10){
            
         
            HStack{
                
                Text("Membership".uppercased())
                    .modifier(CustomModifier(font: .title3, weight: .black))
                
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50,height: 50)
                    .clipShape(Circle())
                
            }
            
            Spacer()
            
              Text("King of Animal")
                .modifier(CustomModifier(font: .body, weight: .semibold))
            
            Text("LION")
                .modifier(CustomModifier(font: .subheadline, weight: .bold))
            
        }
        .padding(20)
        .padding(.vertical,10)
        .blendMode(.overlay)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .topLeading)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIView{
    
    func subViews(forclass : AnyClass?)->UIView?{
        
        return subviews.first { view in
            
            type(of: view) == forclass
        }
        
    }
    
}

extension UIVisualEffectView{
    
    var backDrop : UIView?{
        
        return subViews(forclass: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    var guasianBlur : NSObject?{
        return backDrop?.value(key: "filters", filter: "gaussianBlur")
    
    }
    
    var statulation : NSObject?{
        return backDrop?.value(key: "filters", filter: "colorSturate")
       
    
    }
    
    var gaussianBlurRadius : CGFloat{
        
        get{
            
            return guasianBlur?.values?["inputRadius"] as? CGFloat ?? 0
            
        }
        set{
            
            guasianBlur?.values?["inputRadius"] = newValue
            applyNewEffects()
            
        }
    }
    
    func applyNewEffects(){
        
        UIVisualEffectView.animate(withDuration: 0.5) {
            self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
            
        }
        
    }
    
    var satulationAmount : CGFloat{
        
        get{
            
            return statulation?.values?["inputAmount"] as? CGFloat ?? 0
            
        }
        set{
            
            statulation?.values?["inputAmount"] = newValue
            applyNewEffects()
        }
    }
    
}

extension NSObject{
    
    var values : [String : Any]?{
        get{
            
            return value(forKeyPath: "requestedValues") as? [String : Any]
            
            
        }
        set{
            
            
            setValue(newValue, forKey: "requestedValues")
        }
        
        
    }
    
    
    func value(key : String,filter : String) -> NSObject?{
        
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            
            return obj.value(forKey: "filterType") as? String == filter
        })
    }
    
}



struct CustomBlurView : UIViewRepresentable{
    var effect : UIBlurEffect.Style
    var onChange : (UIVisualEffectView) ->()
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        
        return view
        
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        DispatchQueue.main.async {
            
            onChange(uiView)
            
        }
    }
}

struct CustomModifier : ViewModifier{
    var font : Font
    var weight : Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(weight)
            .foregroundColor(.white)
            .kerning(1.5)
            .shadow(radius: 15)
            .frame(maxWidth: .infinity,alignment: .leading)
            
    }
}
