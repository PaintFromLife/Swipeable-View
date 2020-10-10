import SwiftUI



public struct SwipebleView<T,Content: View>: View  where T: SwipebleViewModel{
    
    var proxy: GeometryProxy
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: T
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content, viewModel: T, geometryProxy: GeometryProxy) {
        self.content = content()
        self.viewModel = viewModel
        self.proxy = geometryProxy
    }
    
    public var body: some View {
        
        ZStack {
            
            HStack {
                Spacer().frame(width: proxy.size.width * (1 - CGFloat(min(4, viewModel.actions.actions.count)) * 0.231), height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                EditActions(viewModel: viewModel.actions)
                
            }

            content
            .frame(maxHeight:.infinity)
            .offset(x: viewModel.dragOffset.width)
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            withAnimation {
                viewModel.dragOffset = CGSize.zero
            }
        })
        
        .gesture(
            DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded { value in
                    withAnimation {
                        if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                            viewModel.dragOffset = CGSize.init(width: -1*(proxy.size.width * (CGFloat(min(4, viewModel.actions.actions.count)) * 0.2)), height: 0)
                        }
                        else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                            viewModel.dragOffset = CGSize.zero
                        }
                    }
                }
        )
    }
}
class example: SwipebleViewModel {
    var dragOffset: CGSize = CGSize.zero
    var actions: EditActionsVM = EditActionsVM([])
}
@available(iOS 14.0, *)
struct SwipebleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
                GeometryReader { reader in
                    SwipebleView(content: {
                        Text("text")
                    }, viewModel: example(), geometryProxy: reader)
                }
        }

    }
}