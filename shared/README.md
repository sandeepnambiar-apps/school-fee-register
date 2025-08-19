# Shared Components Library

This directory contains shared React components that can be used in both your React web app and React Native mobile app.

## 🚀 How It Works

The shared components use **platform-specific imports** to automatically load the right version:
- **Web**: Uses Material-UI components
- **Mobile**: Uses React Native components
- **Same API**: Both versions have identical props and behavior

## 📱 Available Components

### Button
```tsx
import { Button } from '../shared/components';

<Button
  title="Click Me"
  onPress={() => console.log('Pressed!')}
  variant="primary" // primary, secondary, outline
  size="medium"     // small, medium, large
  loading={false}
  disabled={false}
/>
```

### Input
```tsx
import { Input } from '../shared/components';

<Input
  value={text}
  onChangeText={setText}
  placeholder="Enter text..."
  label="Label"
  type="text"       // text, password, email, number
  error="Error message"
  required={true}
/>
```

### LoginForm
```tsx
import { LoginForm } from '../shared/components';

<LoginForm
  onLogin={async (username, password) => {
    // Handle login logic
  }}
  loading={false}
  error="Login failed"
/>
```

## 🔧 Adding New Components

1. **Create the component directory**: `shared/components/NewComponent/`
2. **Create the main component**: `NewComponent.tsx` (with platform detection)
3. **Create web version**: `NewComponent.web.tsx` (using Material-UI)
4. **Create mobile version**: `NewComponent.native.tsx` (using React Native)
5. **Export from index**: Add to `shared/components/index.ts`

## 📋 Example Structure

```
shared/
├── components/
│   ├── Button/
│   │   ├── Button.tsx          # Platform detection
│   │   ├── Button.web.tsx      # Web version (Material-UI)
│   │   ├── Button.native.tsx   # Mobile version (React Native)
│   │   └── index.ts
│   ├── Input/
│   │   ├── Input.tsx
│   │   ├── Input.web.tsx
│   │   ├── Input.native.tsx
│   │   └── index.ts
│   └── index.ts                # Main exports
└── README.md
```

## 🎯 Benefits

- ✅ **Code Reuse**: Write once, use everywhere
- ✅ **Consistent API**: Same props and behavior across platforms
- ✅ **Easy Maintenance**: Update logic in one place
- ✅ **Platform Optimization**: Each platform gets the best UI components
- ✅ **Type Safety**: Full TypeScript support

## 🚀 Usage in Your Apps

### In React Web App:
```tsx
import { Button, Input, LoginForm } from '../shared/components';
// Components automatically use Material-UI
```

### In React Native App:
```tsx
import { Button, Input, LoginForm } from '../shared/components';
// Components automatically use React Native components
```

## 🔄 Migration Path

1. **Start with new features** using shared components
2. **Gradually replace** existing components
3. **Keep both versions** running during transition
4. **Test thoroughly** on both platforms

This approach gives you the best of both worlds - your existing web app keeps working while you build a mobile app with shared code! 